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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setStatusBarBackgroundColor(color: UIColor.clear)
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
            // 提示用戶是不是忘記輸入 textfield ？
            let alertController = UIAlertController(
                title: "錯誤",
                message: "請輸入信箱與密碼",
                preferredStyle: .alert
            )
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
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
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController =
                        UIAlertController(
                            title: "錯誤",
                            message: "無此帳號",
//                            message: error?.localizedDescription,
                            preferredStyle: .alert
                    )
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func logInPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) { 
        
        if signUpEmail.text?.isValidEmail == false {

            let alertController = UIAlertController(
                title: "錯誤",
                message: "信箱格式不符",
                preferredStyle: .alert
            )

            let defaultAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)

        } else if signUpPassword.text?.isPasswordValid == false {

            let alertController = UIAlertController(
                title: "錯誤",
                message: "密碼格式不符",
                preferredStyle: .alert
            )

            let defaultAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
            alertController.addAction(defaultAction)

            self.present(alertController, animated: true, completion: nil)

        } else {
        
            FirebaseManager.shared.signUp(
                withEmail: signUpEmail.text ?? "",
                password: signUpPassword.text ?? "",
                userName: signUpUsername.text ?? "",
                view: self)
        }
    }
}

