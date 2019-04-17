//
//  FirebaseManager.swift
//  Project-2
//
//  Created by User on 2019/4/16.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    private init() {}
    
    static let shared = FirebaseManager()
    
//    func configure() {
//        FirebaseApp.configure()
//    }
    
    let userReference = Firestore.firestore().collection("users")
    
    func signUp(withEmail: String, password: String, userName: String, view: UIViewController) {
            if withEmail.isEmpty == true {
                let alertController = UIAlertController(
                    title: "錯誤",
                    message: "請輸入信箱與密碼",
                    preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                view.present(alertController, animated: true, completion: nil)
                
            } else {
                Auth.auth().createUser(withEmail: withEmail, password: password) { (_, error) in
                    
                    if error == nil {
                        print("You have successfully signed up")
                        
                        guard let currentUser = Auth.auth().currentUser else { return }
                        self.userReference.document(currentUser.uid).setData(
                            [
                                "email": withEmail,
                                "name": userName,
                                "storage": "",
                                "uid": currentUser.uid
                            ])
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        if let tabBarVC =
                            storyboard.instantiateViewController(
                                withIdentifier:
                                String(describing: TabBarViewController.self))
                                as? TabBarViewController {
                            view.present(tabBarVC, animated: true, completion: nil)
                        }
                    } else {
                        let alertController =
                            UIAlertController(
                                title: "錯誤",
//                                message: "此帳號已被註冊",
                                message: error?.localizedDescription,
                                preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        print(error ?? "")
                        view.present(alertController, animated: true, completion: nil)
                    }
            }
        }
    }
    
    func read() {
        
        let userReference = Firestore.firestore().collection("users")
        
        userReference.addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
    func update() {
        
    }
}
