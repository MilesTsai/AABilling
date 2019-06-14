//
//  LoadingViewController.swift
//  Project-2
//
//  Created by User on 2019/4/11.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Lottie

class LoadingViewController: UIViewController {

//    @IBOutlet weak var testView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let animationVoiew = AnimationView(name: "servishero_loading")
        
        self.view.addSubview(animationVoiew)
        animationVoiew.frame.size = CGSize(width: 250, height: 250)
        animationVoiew.center = self.view.center
        animationVoiew.contentMode = .scaleAspectFill
        animationVoiew.loopMode = .loop
        animationVoiew.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(
            withDuration: 1, delay: 0.8,
            animations: {
                self.loadingView.alpha = 0.0
        
        }, completion: { _ in
            Auth.auth().addStateDidChangeListener { (_, user) in
                
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
                
                if let tabBarVC = storyboard.instantiateViewController(
                        withIdentifier: String(describing: TabBarViewController.self)
                    ) as? TabBarViewController {
                    
                        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                    
                        delegate.window?.rootViewController = tabBarVC
                }
            }
        })
    }
}
