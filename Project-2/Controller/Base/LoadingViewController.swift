//
//  LoadingViewController.swift
//  Project-2
//
//  Created by User on 2019/4/11.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {

    @IBOutlet weak var testView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(
            withDuration: 3,
            animations: {
                self.testView.startAnimating()
        }, completion: { _ in
            Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
                
                guard user != nil else {
                    
                    let storyboard = UIStoryboard(name: "LogInAndSignUp", bundle: nil)
                    if let logInVC =
                        storyboard.instantiateViewController(
                            withIdentifier: String(describing: LogInAndSignUpViewController.self))
                            as? LogInAndSignUpViewController {
                        
                        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        
                        delegate.window?.rootViewController = logInVC
                    }
                    return
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let tabBarVC =
                    storyboard.instantiateViewController(
                        withIdentifier: String(describing: TabBarViewController.self)) as? TabBarViewController {
                    self?.present(tabBarVC, animated: true, completion: nil)
                    
                    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    delegate.window?.rootViewController = tabBarVC
                }
            }
        })
    }
}
