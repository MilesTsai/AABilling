//
//  ViewController.swift
//  Project-2
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class LogInAndSignUpViewController: UIViewController {
    
    @IBOutlet weak var LogInEmail: TextFieldPlaceholder!
    
    @IBOutlet weak var LogInPassword: TextFieldPlaceholder!
    
    @IBOutlet weak var SignUpEmail: TextFieldPlaceholder!
    
    @IBOutlet weak var SignUpUsername: TextFieldPlaceholder!
    
    @IBOutlet weak var SignUpPassword: TextFieldPlaceholder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignUpPage(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp" ) {
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Main") {
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func LogInPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Main") {
            present(vc, animated: true, completion: nil)
        }
    }
}

