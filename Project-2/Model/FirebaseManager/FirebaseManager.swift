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
    
//    lazy var billUid = Firestore.firestore().collection("users").document().documentID
    
    func createUserData(userName: String, withEmail: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid).setData(
            [
                UserData.CodingKeys.name.rawValue: userName,
                UserData.CodingKeys.email.rawValue: withEmail,
                UserData.CodingKeys.storage.rawValue: "",
                UserData.CodingKeys.uid.rawValue: currentUser.uid
            ])
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
    
    func createMyBilling(
        billData: BillData, handler: @escaping (String) -> Void
        ) {
        
        guard let currentUser = Auth.auth().currentUser
            else { return }
        let document =
            userReference.document(currentUser.uid)
                .collection(UserEnum.bills.rawValue).document()
        let billUid = document.documentID
        handler(billUid)
        userReference
            .document(currentUser.uid)
            .collection("bills")
            .document(billUid)
            .setData(
                [
                BillData.CodingKeys.name.rawValue:
                    billData.name ?? "",
                BillData.CodingKeys.billName.rawValue:
                    billData.billName ?? "",
                BillData.CodingKeys.amountTotal.rawValue:
                    billData.amountTotal ?? "",
                BillData.CodingKeys.owedAmount.rawValue:
                    billData.owedAmount ?? "",
                BillData.CodingKeys.payAmount.rawValue:
                    billData.payAmount ?? "",
                BillData.CodingKeys.status.rawValue:
                    billData.status ?? "",
                BillData.CodingKeys.uid.rawValue: billData.uid ?? "",
                BillData.CodingKeys.billUid.rawValue: billUid
                ]
        )
    }
    
    func createFriendBilling(
        friendID: String, billName: String,
        amountTotal: Int, owedAmount: Int,
        payAmount: Int, status: Int, billUid: String) {
        
        readUserData()
        guard let currentUser = Auth.auth().currentUser
            else { return }
        dispatchGroup.notify(queue: .main) {
            self.userReference
                .document(friendID)
                .collection(UserEnum.bills.rawValue)
                .document(billUid)
                .setData(
                    [
                        BillData.CodingKeys.name.rawValue: self.userData?.name ?? "",
                        BillData.CodingKeys.billName.rawValue: billName,
                        BillData.CodingKeys.amountTotal.rawValue: amountTotal,
                        BillData.CodingKeys.owedAmount.rawValue: owedAmount,
                        BillData.CodingKeys.payAmount.rawValue: payAmount,
                        BillData.CodingKeys.status.rawValue: status,
                        BillData.CodingKeys.uid.rawValue: currentUser.uid,
                        BillData.CodingKeys.billUid.rawValue: billUid
                    ]
            )
        }
    }
    
    func readUserData(completion: @escaping (UserData) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference
            .document(currentUser.uid)
            .getDocument(completion: { (snapshot, _) in
            let user = snapshot?.data()
            let userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String,
                fcmToken: user?[PersonalData.CodingKeys.fcmToken.rawValue] as? String
            )
            completion(userData)
        })
    }
    
    func readUserData() {
        
        dispatchGroup.enter()
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference
            .document(currentUser.uid)
            .getDocument(completion: { [weak self] (snapshot, _) in
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
                guard error == nil else { return }
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

                guard error == nil else { return }
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
    
    func readBillingDetail(friendUid: String, completion: @escaping ([BillData]) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference
            .document(currentUser.uid)
            .collection(UserEnum.bills.rawValue)
            .whereField("uid", isEqualTo: friendUid)
            .getDocuments(completion: { [weak self] (snapshot, error) in
                    
                guard error == nil else { return }
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
                    var billingList = [BillData]()
                    
                    billingList =
                        snap.documents
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
                    .collection(UserEnum.users.rawValue).document(friendUid)
                    .collection(UserEnum.friends.rawValue).document(currentUser.uid)
                    .updateData(["fcmToken": token])
            }
        }
    }
    
    func updateUserName(name: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference
            .document(currentUser.uid)
            .updateData(["name": name])
    }
    
    func updateDocument(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference
            .document(document)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid).setData([
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
            ])
    }
    
    func updateMyStatus(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid).collection(UserEnum.friends.rawValue)
            .document(document).updateData(["status": 1])
    }
    
    func updateFriendStatus(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(document).collection(UserEnum.friends.rawValue)
            .document(currentUser.uid).updateData(["status": 1])
    }
    
    func updateMyBillStatus(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid).collection(UserEnum.bills.rawValue)
            .document(document).updateData(["status": 2, "owedAmount": 0])
    }
    
    func updateFriendBillStatus(document: String, billID: String) {
        userReference.document(document).collection(UserEnum.bills.rawValue)
            .document(billID).updateData(["status": 2, "owedAmount": 0])
    }
    
    func updateMySum(friendID: String, sum: Int) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid).collection(UserEnum.friends.rawValue)
            .document(friendID).updateData(["totalAccount": sum])
    }
    
    func updateFriendSum(friendID: String, friendSum: Int) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(friendID).collection(UserEnum.friends.rawValue)
            .document(currentUser.uid).updateData(["totalAccount": friendSum])
    }
    
    func updateUserName(friendID: String, name: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(friendID).collection("friends")
            .document(currentUser.uid).updateData(["name": name]
        )
    }
    
    func deleteFriend(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid)
            .collection(UserEnum.friends.rawValue)
            .document(document).delete()
        userReference.document(document)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid).delete()
    }
    
    func deleteBilling(document: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid)
            .collection(UserEnum.bills.rawValue)
            .document(document).delete()
    }
    
    func deleteFriendBilling(document: String, billId: String) {
        userReference.document(document)
            .collection(UserEnum.bills.rawValue)
            .document(billId).delete()
    }
}
