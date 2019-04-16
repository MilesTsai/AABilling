//
//  AddFriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var addEmail: UITextField!
    
    var dataBase: Firestore = Firestore.firestore()
    
    var friendID: String?
    
    var user: PersonalData?

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
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar =
            UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar")
                as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        dataBase
            .collection("users")
            .whereField("email", isEqualTo: addEmail.text ?? "")
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if querySnapshot?.isEmpty == true {
                    print("No exist")
                    let alertController =
                            UIAlertController(
                                title: "錯誤",
                                message: "無此帳號",
                                preferredStyle: .alert
                            )
                    
                    let defaultAction =
                            UIAlertAction(
                                title: "OK",
                                style: .cancel,
                                handler: nil
                            )
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        self.friendID = String(document.documentID)
                        
                        let friend = document.data()
                        
                        self.user =
                                PersonalData(
                                    displayName: friend["displayName"] as? String,
                                    email: friend["email"] as? String,
                                    storage: friend["storage"] as? String
                                )
                    }
                    self.updateDocument(document: self.friendID ?? "")
                    
                    self.dataBase
                            .collection("users")
                            .document(currentUser.uid)
                            .collection("friends")
                            .document(self.friendID ?? "")
                            .setData(
                                ["status": 0,
                                 PersonalData.CodingKeys.displayName.rawValue:
                                    self.user?.displayName ?? "",
                                 PersonalData.CodingKeys.storage.rawValue:
                                    self.user?.storage ?? "",
                                 PersonalData.CodingKeys.email.rawValue:
                                    self.user?.email ?? ""
                                ])
                    
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
                                handler: nil
                        )
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func updateDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let inviteFriend =
                dataBase
                    .collection("users")
                    .document(friendID ?? "")
                    .collection("friends")
                    .document(currentUser.uid)
        
        inviteFriend.setData([
            "status": 1
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    @IBAction func cancelAddFriend(_ sender: UIButton) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
