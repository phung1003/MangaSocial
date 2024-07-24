//
//  ProfileMenuVC.swift
//  MangaSocial
//
//  Created by ATULA on 04/03/2024.
//

import UIKit
import Kingfisher
import JGProgressHUD
import Firebase


class ProfileMenuVC: UIViewController {

    @IBOutlet weak var savedBtn:UIButton!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var webModeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    let hud = JGProgressHUD()
    
    var profile = ProfileModel()
    
    var screenEnterTime: Date?

    
    func viewConfig() {
        self.hud.style = .dark
        self.hud.textLabel.text = "Loading"
        
        avatar.makeRounded()
        
        configButton(button: savedBtn, img: "ProfileSave")
        configButton(button: userBtn, img: "ProfileUser")
        configButton(button: bookmarkBtn, img: "ProfileBookmark")
        configButton(button: historyBtn, img: "ProfileHistory")
        configButton(button: deleteBtn, img: "ProfileDelete")

        APIService.shared.check{ [self](data, error) in
            if APIService.webMode {
       
                configButton(button: webModeBtn, img: "On")
            } else {
                
                configButton(button: webModeBtn, img: "Off")
                
                
            }
        }
        
        logoutBtn.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        loginBtn.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        if APIService.userId <= 0 {
            loginBtn.isHidden = false
            userBtn.isHidden = true
            logoutBtn.isHidden = true
            deleteBtn.isHidden = true
            webModeBtn.isHidden = true
        } else {
            loginBtn.isHidden = true
            userBtn.isHidden = false
            logoutBtn.isHidden = false
            deleteBtn.isHidden = false
            webModeBtn.isHidden = false
        }
        
        setGradientBackground()
    }
    
    func fetchData(){
        print(APIService.userId)
        APIService.shared.getProfile(){ data, error in
            if let data = data
            {
                DispatchQueue.main.async { [self] in
                    profile = data
                    if profile.avatar_user != ""{
                        name.text = profile.name_user
                        avatar.kf.setImage(with: URL(string: profile.avatar_user))
                    }
                }
                
            }
            
        }
    }
    
    func configButton(button: UIButton,  img: String) {
        
        let image = createImage(withSize: CGSize(width: 35, height: 35), named: img)
        
        
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),  // Set the font
            .foregroundColor: UIColor.white,             // Set the text color
        ]
        
        let title = NSAttributedString(string: button.title(for: .normal) ?? "", attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        
    }
    
    
    func createImage(withSize size: CGSize, named imageName: String) -> UIImage? {
        // Load the image from the asset catalog
        if let image = UIImage(named: imageName) {
            // Resize the image to the desired size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(x: -5, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
        return nil
    }
    
    
    func setGradientBackground() {

        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let colorMid = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.68).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMid,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewDidLoad() {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ProfileMenuVC"])
        screenEnterTime = Date()

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        viewConfig()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsLogTimeUsing(screen: "ProfileMenuVC", enterTime: screenEnterTime)
    }
    
    @IBAction func didTapchangeMode() {
        hud.show(in: self.view)
        
        APIService.shared.changeMode{data, error in
            if let data = data {
                self.hud.dismiss()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                
                if !APIService.webMode {
                    if !vc.webServerList.keys.contains(APIService.serverIndex) {
                        APIService.serverIndex = "3"
                        UserDefaults.standard.set("3", forKey: "server")
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else {
                self.hud.dismiss()
            }
        }
    }
    
    
    @IBAction func didTapLogout() {
        APIService.shared.logout() { data, error in
            if let data = data {
                UserDefaults.standard.set("-1", forKey: "id_user")
                APIService.userId = 0
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else {
                print("abc")
                UserDefaults.standard.set("-1", forKey: "id_user")
                APIService.userId = 0
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapLogin() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapDelete() {
        showAlert(title: "Warning", message: "Are you sure you want to delete this account")
    }
    
    @IBAction func didTapBack(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    @IBAction func didTapSave() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapProfile() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapHistory(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc.modalPresentationStyle = .fullScreen
        vc.item = "history"
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapBookMark(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc.modalPresentationStyle = .fullScreen
        vc.item = "bookmark"
        self.present(vc, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var cancel = UIAlertAction(title: "Cancel", style: .cancel)
        var action = UIAlertAction(title: "Delete", style: .default){ [self]action in
            APIService.shared.deleteAccount {data, error in
            }
            UserDefaults.standard.set("-1", forKey: "id_user")
            avatar.image = UIImage(named: "usersquare 1")
            name.text = "Guest"
            APIService.userId = 0
            viewConfig()
        }
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    


}
