//
//  ViewController.swift
//  Project-2
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class LogInAndSignUpViewController: UIViewController {

    @IBOutlet weak var logInEmail: TextFieldPlaceholder!

    @IBOutlet weak var logInPassword: TextFieldPlaceholder!

    @IBOutlet weak var signUpEmail: TextFieldPlaceholder!

    @IBOutlet weak var signUpUsername: TextFieldPlaceholder!

    @IBOutlet weak var signUpPassword: TextFieldPlaceholder!
    
    var dataBase: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBase = Firestore.firestore()
        
        setStatusBarBackgroundColor(color: UIColor.clear)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar =
            UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }

    @IBAction func signUpPage(_ sender: UIButton) {
        if let signUpVC =
            storyboard?.instantiateViewController(withIdentifier: "SignUp" ) {
            present(signUpVC, animated: true, completion: nil)
        }
    }

    @IBAction func logIn(_ sender: UIButton) {
        
        if logInEmail.text == "" || logInPassword.text == "" {
            
            AlertManager().alertView(title: "錯誤", message: "請輸入信箱與密碼", view: self)
            
        } else {
            Auth.auth().signIn(withEmail: self.logInEmail.text!,
                               password: self.logInPassword.text!) { (_, error) in
                
                if error == nil {
                    print("You have successfully logged in")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let tabBarVC =
                        storyboard.instantiateViewController(
                            withIdentifier: String(describing: TabBarViewController.self)) as? TabBarViewController {
                        self.present(tabBarVC, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    AlertManager().alertView(title: "錯誤", message: "無此帳號", view: self)
                }
            }
        }
    }

    @IBAction func logInPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) { 
        
        if signUpEmail.text?.isValidEmail == false {
            
            AlertManager().alertView(title: "錯誤", message: "信箱格式不符", view: self)

        } else if signUpPassword.text?.isPasswordValid == false {

            AlertManager().alertView(title: "錯誤", message: "請輸入英文與數字組成的密碼", view: self)

        } else {
            
            signUp()
        }
    }
    
    func signUp() {
        
        if signUpEmail.text?.isEmpty == true {
            
            AlertManager().alertView(title: "錯誤", message: "請輸入信箱與密碼", view: self)
            
        } else {
            
            Auth.auth().createUser(
            withEmail: signUpEmail.text ?? "",
            password: signUpPassword.text ?? "")
            { [weak self] (_, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    FirebaseManager
                        .shared
                        .createUserData(
                            userName: self?.signUpUsername.text ?? "",
                            withEmail: self?.signUpEmail.text ?? ""
                    )
                }
                
                if let tabBarVC =
                    UIStoryboard.main.instantiateViewController(
                        withIdentifier:
                        String(describing: TabBarViewController.self))
                        as? TabBarViewController {
                    self?.present(tabBarVC, animated: true, completion: nil)
                    
                } else {
                    
                    AlertManager().alertView(title: "錯誤", message: error?.localizedDescription ?? "", view: self!)
                }
            }
        }
    }
}
