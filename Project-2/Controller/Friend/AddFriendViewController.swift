//
//  AddFriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var addEmail: UITextField!
    
    var friendID: String?
    
    var completion: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.contentView.isHidden = false
            self?.addEmail.becomeFirstResponder()
        })
        
        setStatusBarBackgroundColor(color: UIColor.clear)
        
        guard let rootViewVC = UIApplication.shared.keyWindow?.rootViewController
            as? TabBarViewController else { return }
        rootViewVC.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let rootViewVC = UIApplication.shared.keyWindow?.rootViewController
            as? TabBarViewController else { return }
        rootViewVC.tabBar.isHidden = false
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar =
            UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar")
                as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        FirebaseManager.shared.readFreind(email: addEmail.text ?? "") { [weak self] (completion) in
            self?.completion = completion
            
            if completion == true {
                
                AlertManager().alertView(title: "錯誤", message: "無此帳號", view: self!)
            } else {
                
                let alertController =
                    UIAlertController(
                        title: "成功",
                        message: "已寄出好友邀請",
                        preferredStyle: .alert
                )
                
                let defaultAction =
                    UIAlertAction(
                        title: "OK",
                        style: .cancel,
                        handler: { [weak self] _ in
                            self?.presentingViewController?.dismiss(animated: false, completion: nil)
                            
                            self?.addEmail.text = ""
                    })
                
                alertController.addAction(defaultAction)
                
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelAddFriend(_ sender: UIButton) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
