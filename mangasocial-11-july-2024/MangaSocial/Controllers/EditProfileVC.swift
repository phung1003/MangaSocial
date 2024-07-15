//
//  EditProfileVC.swift
//  MangaSocial
//
//  Created by ATULA on 08/03/2024.
//

import UIKit
import JGProgressHUD

class EditProfileVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var job: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var anotherBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var introduction: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var line: UIImageView!
    
    var hud = JGProgressHUD()
    var userProfile = ProfileModel()
    
    let attribute:[NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),  // Set the font
        .foregroundColor: UIColor.black,             // Set the text color
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        job.delegate = self
        introduction.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewConfig()
        fetchData()
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(endEdit))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
        
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        username.bottomBorder(color: UIColor.black.cgColor)
        job.bottomBorder(color: UIColor.black.cgColor)
    }
    
    @objc func endEdit() {
        print("as")
        view.endEditing(true)
    }
    
    func fetchData() {
        username.text = userProfile.name_user
        job.text = userProfile.job
        introduction.text = userProfile.introduction
        
        var date_of_birth = userProfile.date_of_birth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: date_of_birth) {
            birthday.setDate(date, animated: true)
        } else {
            print("Unable to convert string to date.")
        }
        
        avatar.kf.setImage(with: URL(string: userProfile.avatar_user))
        
        switch userProfile.gender {
        case "male":
            maleBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
            femaleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
            anotherBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        case "female":
            maleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
            femaleBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
            anotherBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        default:
            maleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
            femaleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
            anotherBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
        }
    }
    
    func viewConfig() {
//        maleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
//        femaleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
//        anotherBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)

//        submit.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        submit.layer.cornerRadius = 8
//        submit.layer.borderWidth = 1
//        submit.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//       
        avatar.makeRounded()
        setGradientBackground()
        
        hud.style = .dark
        hud.textLabel.text = "Loading"
    }
    
    func setGradientBackground() {

        let colorTop =  UIColor(red: 0.953, green: 0.639, blue: 0.016, alpha: 1).cgColor
        let colorMid = UIColor(red: 0.946, green: 0.789, blue: 0.478, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.953, green: 0.639, blue: 0.016, alpha: 0.68).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMid,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.bottomBorder(color: #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.bottomBorder(color: UIColor.black.cgColor)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        line.backgroundColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        line.backgroundColor = .black

    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }


        guard let screen = notification.object as? UIScreen,
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }


        // Use that screen to get the coordinate space to convert from.
        let fromCoordinateSpace = screen.coordinateSpace


        // Get your view's coordinate space.
        let toCoordinateSpace: UICoordinateSpace = view


        // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
        
        // Get the safe area insets when the keyboard is offscreen.
        var bottomOffset = view.safeAreaInsets.bottom
            
        // Get the intersection between the keyboard's frame and the view's bounds to work with the
        // part of the keyboard that overlaps your view.
        let viewIntersection = view.bounds.intersection(convertedKeyboardFrameEnd)
            
        // Check whether the keyboard intersects your view before adjusting your offset.
        if !viewIntersection.isEmpty {
                
            // Adjust the offset by the difference between the view's height and the height of the
            // intersection rectangle.
            bottomOffset = view.bounds.maxY - viewIntersection.minY
        }


        // Use the new offset to adjust your UI, for example by changing a layout guide, offsetting
        // your view, changing a scroll inset, and so on. This example uses the new offset to update
        // the value of an existing Auto Layout constraint on the view.
        bottomConstraint.constant = -bottomOffset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 0
    }
    
    
    @IBAction func didTapMale() {
        userProfile.gender = "male"
        maleBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
        femaleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        anotherBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
    }
    
    @IBAction func didTapFemale() {
        userProfile.gender = "female"
        maleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        femaleBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
        anotherBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
    }
    
    @IBAction func didTapAnother() {
        userProfile.gender = "undisclosed"
        maleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        femaleBtn.configButton(img: "boxUnchecked", imgSize: 20, attributes: attribute)
        anotherBtn.configButton(img: "boxChecked", imgSize: 20, attributes: attribute)
    }
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
    
    func showAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var action = UIAlertAction(title: "OK", style: .default){action in
            self.dismiss(animated: true)
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func didTapSubmit() {
        userProfile.name_user = username.text ?? ""
        userProfile.job = job.text ?? ""
        userProfile.introduction = introduction.text
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        userProfile.date_of_birth = dateFormatter.string(from: birthday.date)
        print(userProfile.date_of_birth)
        hud.show(in: self.view)
        APIService.shared.editProfile(userProfile: userProfile) {data, error in
            DispatchQueue.main.async {
                self.hud.dismiss(animated: true)
                if let data = data {
                    self.showAlert(title:"", message: data)
                }
                else {
                    self.showAlert(title: "Error", message: error ?? "")
                }
            }
        }
    }

}

extension EditProfileVC: UIImagePickerControllerDelegate {
    @objc func pickImage() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
    fileprivate func imageSelected(_ selectedImage: UIImage) {
        avatar.image = selectedImage
        hud.show(in: self.view)
        APIService.shared.postImage(image: selectedImage.toBase64()) { data, error in
            DispatchQueue.main.async {
                self.hud.dismiss()
                if let data = data {
                    self.userProfile.avatar_user = data
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageSelected(selectedImage)
            }
            dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}
