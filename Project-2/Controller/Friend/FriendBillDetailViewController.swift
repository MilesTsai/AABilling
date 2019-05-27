//
//  FriendBillDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class FriendBillDetailViewController: BaseViewController {
    
    var billingDetailData: BillData?
    
    var splitBillDetailVC: SplitBillDetailViewController?
    
    var friendBillingUid: String?
    
    var myTotalAccount: PersonalData?
    
    var friendTotalAccount: PersonalData?
    
    var friendBilling: BillData?
    
    var dataBase: Firestore = Firestore.firestore()
    
    let dispatchGroup = DispatchGroup()
    
    var mySelfTotalAccount: Int = 0
    
    var myfriendTotalAccount: Int = 0
    
    var myfriendOwedAmount: Int = 0
    
    @IBOutlet weak var billName: UILabel!
    
    @IBOutlet weak var amountTotal: UILabel!
    
    @IBOutlet weak var myAccountStatus: UILabel!
    
    @IBOutlet weak var friendAccountStatus: UILabel!
    
    @IBOutlet weak var settleUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitBillDetailVC?.friendBillingUid = { [weak self] uid in
            self?.friendBillingUid = uid
        }
        
        if billingDetailData?.status == 2 && friendBilling?.status == 2 {
            settleUpBtn.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        billName.text = billingDetailData?.billName
        
        guard let total = billingDetailData?.amountTotal else { return }
        
        amountTotal.text = "$\(total)"
        
        guard let friendName = billingDetailData?.name else { return }
        
        guard let pay = billingDetailData?.payAmount else { return }
        
        guard var owe = billingDetailData?.owedAmount else { return }
        
        guard let money = billingDetailData?.amountTotal else { return }
        
        myAccountStatus.text = "$\(0)"
        
        friendAccountStatus.text = "$\(0)"
        
        if owe > 0 {
            myAccountStatus.text = "你付了 $\(pay)，需取回 $\(owe)"
            friendAccountStatus.text = "\(friendName) 欠你 $\(owe)"
        } else if owe < 0 {
            owe.negate()
            myAccountStatus.text = "你欠 \(friendName) $\(owe)"
            friendAccountStatus.text = "\(friendName)付了 $\(money - pay)，需取回 $\(owe)"
        }
        
    }
    
    @IBAction func backFreindDetail(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func readFriendTotalAccountData() {
        
        dispatchGroup.enter()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        dataBase
            .collection(UserEnum.users.rawValue)
            .document(friendUid)
            .collection(UserEnum.friends.rawValue)
            .document(currentUser.uid)
            .getDocument(completion: { [weak self] (snapshot, _) in
                
            let friend = snapshot?.data()
            self?.friendTotalAccount = PersonalData(
                name: friend?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: friend?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: friend?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: friend?[PersonalData.CodingKeys.uid.rawValue] as? String,
                status: friend?[PersonalData.CodingKeys.status.rawValue] as? Int,
                totalAccount: friend?[PersonalData.CodingKeys.totalAccount.rawValue] as? Int,
                fcmToken: friend?[PersonalData.CodingKeys.fcmToken.rawValue] as? String
            )
            
            guard let myfriend = self?.friendTotalAccount?.totalAccount else { return }
            
            self?.myfriendTotalAccount = myfriend
            
            self?.dispatchGroup.leave()
        })
    }
    
    func readFriendBillOwedAmount() {
        
        dispatchGroup.enter()
        
        guard let billingUid = billingDetailData?.billUid else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        
        dataBase
            .collection(UserEnum.users.rawValue)
            .document(friendUid)
            .collection(UserEnum.bills.rawValue)
            .document(billingUid)
            .getDocument(completion: { [weak self] (snapshot, _) in
                
            let friendBill = snapshot?.data()
            self?.friendBilling = BillData(
                uid: friendBill?[BillData.CodingKeys.uid.rawValue] as? String,
                billUid: friendBill?[BillData.CodingKeys.billUid.rawValue] as? String,
                name: friendBill?[BillData.CodingKeys.name.rawValue] as? String,
                billName: friendBill?[BillData.CodingKeys.billName.rawValue] as? String,
                amountTotal: friendBill?[BillData.CodingKeys.amountTotal.rawValue] as? Int,
                owedAmount: friendBill?[BillData.CodingKeys.owedAmount.rawValue] as? Int,
                payAmount: friendBill?[BillData.CodingKeys.payAmount.rawValue] as? Int,
                status: friendBill?[BillData.CodingKeys.status.rawValue] as? Int)
            
            guard let myfriendBill = self?.friendBilling?.owedAmount else { return }
            
            self?.myfriendOwedAmount = myfriendBill
            
            self?.dispatchGroup.leave()
        })
    }
    
    func readMyTotalAccount() {
        
        dispatchGroup.enter()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        
        dataBase
            .collection(UserEnum.users.rawValue)
            .document(currentUser.uid)
            .collection(UserEnum.friends.rawValue)
            .document(friendUid)
            .getDocument(completion: { [weak self] (snapshot, _) in
                
            let user = snapshot?.data()
            self?.myTotalAccount = PersonalData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String,
                status: user?[PersonalData.CodingKeys.status.rawValue] as? Int,
                totalAccount: user?[PersonalData.CodingKeys.totalAccount.rawValue] as? Int,
                fcmToken: user?[PersonalData.CodingKeys.fcmToken.rawValue] as? String
            )
            
            guard let selfTotalAccount = self?.myTotalAccount?.totalAccount else { return }
            
            self?.mySelfTotalAccount = selfTotalAccount
            
            self?.dispatchGroup.leave()
            
        })
    }
    
    func updateMyTotalAccount() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        
        self.dataBase
            .collection(UserEnum.users.rawValue)
            .document(currentUser.uid).collection(UserEnum.friends.rawValue)
            .document(friendUid)
            .updateData(["totalAccount": mySelfTotalAccount + myfriendOwedAmount])
    }
    
    func updateFriendTotalAccount() {
        
        guard let myOwedAmount = self.billingDetailData?.owedAmount else { return }
        
        guard let friendUid = self.billingDetailData?.uid else { return }
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        self.dataBase
            .collection(UserEnum.users.rawValue)
            .document(friendUid).collection(UserEnum.friends.rawValue)
            .document(currentUser.uid)
            .updateData(["totalAccount": self.myfriendTotalAccount + myOwedAmount])
    }
    
    @IBAction func settleUpBtn(_ sender: UIButton) {
        
        guard let billingUid = self.billingDetailData?.billUid else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("settleUp"),
            object: nil,
            userInfo: ["billingUid": billingUid]
        )
        
        readMyTotalAccount()
        readFriendTotalAccountData()
        readFriendBillOwedAmount()
        
        dispatchGroup.notify(queue: .main) {
            
            guard let billingUid = self.billingDetailData?.billUid else { return }
            
            guard let friendUid = self.billingDetailData?.uid else { return }
            
            self.updateFriendTotalAccount()
            
            self.updateMyTotalAccount()
            
            FirebaseManager.shared.updateMyBillStatus(document: billingUid)
            FirebaseManager.shared.updateFriendBillStatus(document: friendUid, billID: billingUid)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func friendBillEdit(_ sender: UIBarButtonItem) {
        if let billEditVC = storyboard?.instantiateViewController(withIdentifier: "FriendBillEdit") {
            
            present(billEditVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func accountDelete(_ sender: Any) {
        
        guard let billingUid = billingDetailData?.billUid else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteBilling"),
            object: nil,
            userInfo: ["billingUid": billingUid]
        )
        
        FirebaseManager.shared.deleteBilling(document: billingUid)
        FirebaseManager.shared.deleteFriendBilling(document: friendUid, billId: billingUid)
        
        dismiss(animated: true, completion: nil)
    }
    
}
