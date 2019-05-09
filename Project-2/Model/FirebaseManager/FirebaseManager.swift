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
    
    func configure() {
        FirebaseApp.configure()
    }
    
    var userData: UserData?
    
    var friendData: PersonalData?
    
    var friendBill: BillData?
    
    let dispatchGroup = DispatchGroup()
    
    lazy var userReference = Firestore.firestore().collection("users")
    
    func signUp(withEmail: String, password: String, userName: String, view: UIViewController) {
            if withEmail.isEmpty == true {
                
                AlertManager().alertView(title: "錯誤", message: "請輸入信箱與密碼", view: view)
                
            } else {
                Auth.auth().createUser(withEmail: withEmail, password: password) { [weak self] (_, error) in
                    
                    if error == nil {
                        print("You have successfully signed up")
                        
                        guard let currentUser = Auth.auth().currentUser else { return }
                        self?.userReference.document(currentUser.uid).setData(
                            [
                                UserData.CodingKeys.name.rawValue: userName,
                                UserData.CodingKeys.email.rawValue: withEmail,
                                UserData.CodingKeys.storage.rawValue: "",
                                UserData.CodingKeys.uid.rawValue:
                                    currentUser.uid
                            ])
                        
                        if let tabBarVC =
                            UIStoryboard.main.instantiateViewController(
                                withIdentifier:
                                String(describing: TabBarViewController.self))
                                as? TabBarViewController {
                            view.present(tabBarVC, animated: true, completion: nil)
                        }
                    } else {
                        
                        AlertManager().alertView(title: "錯誤", message: error?.localizedDescription ?? "", view: view)
                        let alertController =
                            UIAlertController(
                                title: "錯誤",
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
    
    func createFriend(friendID: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference
            .document(currentUser.uid)
            .collection(UserEnum.friends.rawValue)
            .document(friendID)
            .setData(
                [
                    PersonalData.CodingKeys.status.rawValue:
                    2,
                    PersonalData.CodingKeys.name.rawValue:
                        friendData?.name ?? "",
                    PersonalData.CodingKeys.storage.rawValue:
                        friendData?.storage ?? "",
                    PersonalData.CodingKeys.email.rawValue:
                        friendData?.email ?? "",
                    PersonalData.CodingKeys.uid.rawValue:
                        friendData?.uid ?? "",
                    PersonalData.CodingKeys.totalAccount.rawValue: 0,
                    
                    PersonalData.CodingKeys.fcmToken.rawValue:
                        friendData?.fcmToken ?? ""
                ])
    }
    
    func readUserData() {
        
        dispatchGroup.enter()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).getDocument(completion: { [weak self] (snapshot, _) in
            let user = snapshot?.data()
            self?.userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String,
                fcmToken: user?[PersonalData.CodingKeys.fcmToken.rawValue] as? String
            )
            self?.dispatchGroup.leave()
        })
    }
    
    func readFreind(email: String, completion: @escaping (Bool) -> Void) {
        
        userReference
            .whereField("email", isEqualTo: email)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if querySnapshot?.isEmpty == true {
                        
                        completion(true)
                        
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            let friendData = document.data()
                            
                            self?.friendData =
                                PersonalData(
                                    name: friendData["name"] as? String,
                                    email: friendData["email"] as? String,
                                    storage: friendData["storage"] as? String,
                                    uid: friendData["uid"] as? String,
                                    status: friendData["status"] as? Int,
                                    totalAccount: friendData["totalAccount"] as? Int,
                                    fcmToken: friendData["fcmToken"] as? String
                            )
                            self?.readUserData()
                            
                            self?.dispatchGroup.notify(queue: .main) {
                                
                                self?.createFriend(friendID: String(document.documentID))
                                
                                self?.updateDocument(document: String(document.documentID))
                            }
                            
                            completion(false)
                        }
                    }
                }
            }
    }
    
    func readUserFriendData(friendUid: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference
            .document(friendUid)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid)
            .getDocument(completion: { [weak self] (snapshot, _) in
                
            let friend = snapshot?.data()
            self?.friendData = PersonalData(
                name: friend?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: friend?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: friend?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: friend?[PersonalData.CodingKeys.uid.rawValue] as? String,
                status: friend?[PersonalData.CodingKeys.status.rawValue] as? Int,
                totalAccount: friend?[PersonalData.CodingKeys.totalAccount.rawValue] as? Int,
                fcmToken: friend?[PersonalData.CodingKeys.fcmToken.rawValue] as? String)
            
        })
    }
    
    func readFriendListData(completion: @escaping ([PersonalData]) -> Void) {

        guard let currentUser = Auth.auth().currentUser else { return }

        userReference
            .document(currentUser.uid)
            .collection(UserEnum.friends.rawValue)
            .order(by: "name", descending: false)
            .addSnapshotListener { querySnapshot, error in

                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    guard let snapshot =
                        querySnapshot else { return }

                    var friendLists = [PersonalData]()
                    
                    friendLists =
                        snapshot
                            .documents
                            .compactMap({
                                PersonalData(dictionary: $0.data())
                            })
                    completion(friendLists)
                }
        }
    }
    
    func readBillingDetail(friendUid: String, completion: @escaping ([BillData]) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference
            .document(currentUser.uid)
            .collection(UserEnum.bills.rawValue)
            .whereField("uid", isEqualTo: friendUid)
            .getDocuments(completion: { [weak self] (snapshot, error) in
                
                if let error = error {
                    print(error)
                } else {
                    
                    guard let snap = snapshot else { return }
                    
                    for document in snap.documents {
                        
                        let billDetail = document.data()
                        
                        self?.friendBill =
                            BillData(
                                uid: billDetail["uid"] as? String,
                                billUid: billDetail["billUid"] as? String,
                                name: billDetail["name"] as? String,
                                billName: billDetail["billName"] as? String,
                                amountTotal: billDetail["amountTotal"] as? Int,
                                owedAmount: billDetail["owedAmount"] as? Int,
                                payAmount: billDetail["payAmount"] as? Int,
                                status: billDetail["status"] as? Int
                        )
                    }
                    
                    var billingList = [BillData]()
                    
                    billingList =
                        snap
                            .documents
                            .compactMap({
                                BillData(dictionary: $0.data())
                            })
                    
                    completion(billingList)
                }
            })
    }
    
    func updateToken(friends: [PersonalData]) {

        guard let token = Messaging.messaging().fcmToken else { return }

        guard let currentUser = Auth.auth().currentUser else { return }

        for list in friends {
            if let friendUid = list.uid {
                Firestore.firestore()
                    .collection(UserEnum.users.rawValue)
                    .document(friendUid)
                    .collection(UserEnum.friends.rawValue)
                    .document(currentUser.uid)
                    .updateData(["fcmToken": token])
            }
        }
    }
    
    func updateUserName(name: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).updateData(["name": name])
    }
    
    func updateDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference
            .document(document)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid)
            .setData([
                PersonalData.CodingKeys.status.rawValue:
                0,
                PersonalData.CodingKeys.name.rawValue:
                    userData?.name ?? "",
                PersonalData.CodingKeys.storage.rawValue:
                    userData?.storage ?? "",
                PersonalData.CodingKeys.email.rawValue:
                    userData?.email ?? "",
                PersonalData.CodingKeys.uid.rawValue:
                    currentUser.uid ,
                PersonalData.CodingKeys.totalAccount.rawValue: 0,
                PersonalData.CodingKeys.fcmToken.rawValue: userData?.fcmToken ?? ""
                    
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
        
    }
    
    func updateMyStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection(UserEnum.friends.rawValue).document(document).updateData(["status": 1])
        
    }
    
    func updateFriendStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(document).collection(UserEnum.friends.rawValue).document(currentUser.uid).updateData(["status": 1])
    }
    
    func updateMyBillStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection(UserEnum.bills.rawValue).document(document).updateData(["status": 2, "owedAmount": 0])
    }
    
    func updateFriendBillStatus(document: String, billID: String) {
        userReference.document(document).collection(UserEnum.bills.rawValue).document(billID).updateData(["status": 2, "owedAmount": 0])
    }
    
    func deleteFriend(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference
            .document(currentUser.uid)
            .collection(UserEnum.friends.rawValue)
            .document(document)
            .delete()
        
        userReference
            .document(document)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid)
            .delete()
        
    }
    
    func deleteBilling(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection(UserEnum.bills.rawValue).document(document).delete()
        
    }
    
    func deleteFriendBilling(document: String, billId: String) {
        userReference.document(document).collection(UserEnum.bills.rawValue).document(billId).delete()
        
    }
}
