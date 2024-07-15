//
//  SignupVC.swift
//  MangaSocial
//
//  Created by ATULA on 24/01/2024.
//

import UIKit
import JGProgressHUD
class SignupVC: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var passwordConfirmTf: UITextField!
    @IBOutlet weak var signupBtn:UIButton!
    @IBOutlet weak var login: UILabel!
    
    var hud = JGProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        // Do any additional setup after loading the view.
        
        login.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(back(_:)))
        login.addGestureRecognizer(tap)
    }
    

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        var action = UIAlertAction(title: "OK", style: .cancel)
        if message == "Please check your email or spam" {
            action = UIAlertAction(title: "OK", style: .default){action in
                self.dismiss(animated: true)
            }
            
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func viewConfig() {
        hud.style = .dark
        hud.textLabel.text = "Loading"
        
        signupBtn.layer.cornerRadius = 20
        
        emailTf.layer.borderWidth = 1
        passwordTf.layer.borderWidth = 1
        usernameTf.layer.borderWidth = 1
        passwordConfirmTf.layer.borderWidth = 1
        
        emailTf.clipsToBounds = true
        passwordTf.clipsToBounds = true
        usernameTf.clipsToBounds = true
        passwordConfirmTf.clipsToBounds = true
        
        emailTf.layer.cornerRadius = 10
        passwordTf.layer.cornerRadius = 10
        usernameTf.layer.cornerRadius = 10
        passwordConfirmTf.layer.cornerRadius = 10
        
        
        
        
        
        
        emailTf.addLeftImage(name: "email")
        passwordTf.addLeftImage(name: "password")
        usernameTf.addLeftImage(name: "username")
        passwordConfirmTf.addLeftImage(name: "passwordConfirm")
        
        addShowPassword()
        
    }
    
    @IBAction func didTapSignup() {
        if emailTf.text == "" {
            showAlert(message: "Email cannot be null")
        } else if usernameTf.text == "" {
            showAlert(message: "Username cannot be null")
        } else if passwordTf.text == ""
        {
            showAlert(message: "Password cannot be null")
        } else if passwordTf.text != passwordConfirmTf.text
        {
            showAlert(message: "Password does not match")
        } else {
            hud.show(in: self.view)
            APIService.shared.register(email: emailTf.text!, password: passwordTf.text!, username: usernameTf.text!)
            { data, error in
                self.hud.dismiss()
                if let data = data{
                    DispatchQueue.main.async { [self] in
                        if data.errCode == 200 {
                            showAlert(message: data.message)
                        }
                        else
                        {
                            showAlert(message: data.message)
                        }
                    }
                    
                }
            }
        }

    }
    
    
    fileprivate func addShowPassword() {
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "eye")
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        container.addSubview(imageView)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(passwordTouch(_:)))
        container.addGestureRecognizer(longPressGesture)
        
        passwordTf.rightView = container
        passwordTf.rightViewMode = .always
        
        let imageView2 = UIImageView(frame: CGRect(x: -5, y: 0, width: 20, height: 20))
        imageView2.image = UIImage(named: "eye")
        let container2 = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        container2.addSubview(imageView2)
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(passwordCfTouch(_:)))
        container2.addGestureRecognizer(longPressGesture2)
        
        passwordConfirmTf.rightView = container2
        passwordConfirmTf.rightViewMode = .always
        
    }
    
    
    
    @objc func passwordTouch(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // User is holding down
            passwordTf.isSecureTextEntry = false
        } else if gesture.state == .ended {
            // User has released the hold
            passwordTf.isSecureTextEntry = true
        }
    }
    
    @objc func passwordCfTouch(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // User is holding down
            passwordConfirmTf.isSecureTextEntry = false
        } else if gesture.state == .ended {
            // User has released the hold
            passwordConfirmTf.isSecureTextEntry = true
        }
    }
    
    
    @objc func back(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @IBAction func done1(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done2(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done3(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done4(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
