//
//  ViewController.swift
//  Project-2
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class LogInAndSignUpViewController: UIViewController {

    @IBOutlet weak var logInEmail: TextFieldPlaceholder!

    @IBOutlet weak var logInPassword: TextFieldPlaceholder!

    @IBOutlet weak var signUpEmail: TextFieldPlaceholder!

    @IBOutlet weak var signUpUsername: TextFieldPlaceholder!

    @IBOutlet weak var signUpPassword: TextFieldPlaceholder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpPage(_ sender: UIButton) {
        if let signUpVC =
            storyboard?.instantiateViewController(withIdentifier: "SignUp" ) {
            present(signUpVC, animated: true, completion: nil)
        }

    }

    @IBAction func logIn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC =
            storyboard.instantiateViewController(
                withIdentifier: String(describing: TabBarViewController.self)) as? TabBarViewController {
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }

    @IBAction func logInPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC =
            storyboard.instantiateViewController(
                withIdentifier: String(describing: TabBarViewController.self)) as? TabBarViewController {
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
}
