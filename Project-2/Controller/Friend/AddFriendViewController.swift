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
    
    var friend: PersonalData?
    
    var userData: UserData?

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
        
        guard let rootViewVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
        rootViewVC.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let rootViewVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
        rootViewVC.tabBar.isHidden = false
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
                        
                        self.friend =
                                PersonalData(
                                    name: friend["name"] as? String,
                                    email: friend["email"] as? String,
                                    storage: friend["storage"] as? String,
                                    uid: friend["uid"] as? String,
                                    status: friend["status"] as? Int,
                                    totalAccount: friend["totalAccount"] as? Int,
                                    fcmToken: friend["fcmToken"] as? String
                                )
                    }
                    self.updateDocument(document: self.friendID ?? "")
                    
                    self.dataBase
                            .collection("users")
                            .document(currentUser.uid)
                            .collection("friends")
                            .document(self.friendID ?? "")
                            .setData(
                                [
                                    PersonalData.CodingKeys.status.rawValue:
                                        2,
                                    PersonalData.CodingKeys.name.rawValue:
                                        self.friend?.name ?? "",
                                    PersonalData.CodingKeys.storage.rawValue:
                                        self.friend?.storage ?? "",
                                    PersonalData.CodingKeys.email.rawValue:
                                        self.friend?.email ?? "",
                                    PersonalData.CodingKeys.uid.rawValue:
                                        self.friend?.uid ?? "",
                                    PersonalData.CodingKeys.totalAccount.rawValue: 0,
                                    
                                    PersonalData.CodingKeys.fcmToken.rawValue:
                                        self.friend?.fcmToken ?? ""
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
                                handler: { [weak self] _ in
                                    self?.presentingViewController?.dismiss(animated: false, completion: nil)
                                    
                                    self?.addEmail.text = ""
                            })
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func updateDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        dataBase.collection("users").document(currentUser.uid).getDocument(completion: { (snapshot, error) in
            let user = snapshot?.data()
            self.userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String,
                fcmToken: user?[PersonalData.CodingKeys.fcmToken.rawValue] as? String
            )
            print(self.userData ?? "")
            
            self.dataBase
                .collection("users")
                .document(document)
                .collection("friends")
                .document(currentUser.uid)
                .setData([
                    PersonalData.CodingKeys.status.rawValue:
                    0,
                    PersonalData.CodingKeys.name.rawValue:
                        self.userData?.name ?? "",
                    PersonalData.CodingKeys.storage.rawValue:
                        self.userData?.storage ?? "",
                    PersonalData.CodingKeys.email.rawValue:
                        self.userData?.email ?? "",
                    PersonalData.CodingKeys.uid.rawValue:
                        currentUser.uid ,
                    PersonalData.CodingKeys.totalAccount.rawValue: 0,
                    PersonalData.CodingKeys.fcmToken.rawValue: self.userData?.fcmToken ?? ""
                    
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
            }
        })
    }
    
    @IBAction func cancelAddFriend(_ sender: UIButton) {

        presentingViewController?.dismiss(animated: false, completion: nil)
//        view.removeFromSuperview()
    }

}
