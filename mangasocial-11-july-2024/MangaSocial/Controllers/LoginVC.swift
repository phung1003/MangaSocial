//
//  LoginVC.swift
//  MangaSocial
//
//  Created by ATULA on 24/01/2024.
//

import UIKit
import JGProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var forgot: UILabel!
    var hud = JGProgressHUD()
    
    override func viewDidAppear(_ animated: Bool) {
        if let storedValue = UserDefaults.standard.string(forKey: "id_user")
        {
            let n = Int(storedValue)!
            if n > -1 {
                if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
                    login(email: email, password: password)
                }
                else {
                    
                }
            }
        } else
        {
            print("???")
        }
    }
    
    override func viewDidLoad() {
        viewConfig()
        forgot.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(forgotHandler(_:)))
        forgot.addGestureRecognizer(tap)
        super.viewDidLoad()
       
    }
    
    fileprivate func login(email: String, password: String) {
        hud.show(in: self.view)
        APIService.shared.Login(email: email, password: password)
        { data, error in
            DispatchQueue.main.async { [self] in
            self.hud.dismiss()
            if let data = data{
                    if data.errCode == 200 {
                        APIService.userId = data.account.id_user
                        print(APIService.userId)
                        UserDefaults.standard.set(data.account.id_user, forKey: "id_user")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                        APIService.isLogin = true
                        self.dismiss(animated: true)
                    }
                    else 
                    {
                        showAlert(message: data.message)
                    }
                }
                
            }
        }
    }
    
    @objc func forgotHandler(_ gesture: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func didTapLogin() {
        print(APIService.isLogin)
        if emailTf.text == "" {
            showAlert(message: "Email cannot be null")
        } else if passwordTf.text == ""
        {
            showAlert(message: "Password cannot be null")
        } else
        {
            login(email: emailTf.text!, password: passwordTf.text!)
        }
    }
    
    @IBAction func didTapBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapSignup() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
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
    }
    
    func viewConfig() {
        hud.style = .dark
        hud.textLabel.text = "Loading"
        
        loginBtn.layer.cornerRadius = 20
        signupBtn.layer.cornerRadius = 20
        
        emailTf.layer.borderWidth = 1
        passwordTf.layer.borderWidth = 1
        
        emailTf.clipsToBounds = true
        passwordTf.clipsToBounds = true
        
        emailTf.layer.cornerRadius = 10
        passwordTf.layer.cornerRadius = 10
        
        emailTf.addLeftImage(name: "email")
        passwordTf.addLeftImage(name: "password")
        
        addShowPassword()
    }
    
    
    @IBAction func done1(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func done2(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
