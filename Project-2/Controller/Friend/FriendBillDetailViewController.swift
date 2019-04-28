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
    
    var dataBase: Firestore = Firestore.firestore()
    
    @IBOutlet weak var billName: UILabel!
    
    @IBOutlet weak var amountTotal: UILabel!
    
    @IBOutlet weak var myAccountStatus: UILabel!
    
    @IBOutlet weak var friendAccountStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitBillDetailVC?.friendBillingUid = { [weak self] uid in
            self?.friendBillingUid = uid
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
    
    @IBAction func settleUpBtn(_ sender: UIButton) {
        
        guard let billingUid = billingDetailData?.billUid else { return }
        
        guard let friendUid = billingDetailData?.uid else { return }
        
        NotificationCenter.default.post(name: NSNotification.Name("settleUp"), object: nil, userInfo: ["billingUid": billingUid])
        
        FirebaseManager.shared.updateMyBillStatus(document: billingUid)
        FirebaseManager.shared.updateFriendBillStatus(document: friendUid, billID: billingUid)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        dataBase.collection("users").document(currentUser.uid).collection("friends").document(friendUid).getDocument(completion: { [weak self] (snapshot, error) in
            let user = snapshot?.data()
            self?.myTotalAccount = PersonalData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String,
                status: user?[PersonalData.CodingKeys.status.rawValue] as? Int,
                totalAccount: user?[PersonalData.CodingKeys.totalAccount.rawValue] as? Int)
            
            guard let mySelfTotalAccount = self?.myTotalAccount?.totalAccount else { return }
            
            guard let myOwedAmount = self?.billingDetailData?.owedAmount else { return }
            
            self?.dataBase
                .collection("users")
                .document(currentUser.uid).collection("friends")
                .document(friendUid)
                .updateData(["totalAccount": mySelfTotalAccount + myOwedAmount])
        })
        
        dataBase.collection("users").document(friendUid).collection("friends").document(currentUser.uid).getDocument(completion: { [weak self] (snapshot, error) in
            let friend = snapshot?.data()
            self?.friendTotalAccount = PersonalData(
                name: friend?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: friend?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: friend?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: friend?[PersonalData.CodingKeys.uid.rawValue] as? String,
                status: friend?[PersonalData.CodingKeys.status.rawValue] as? Int,
                totalAccount: friend?[PersonalData.CodingKeys.totalAccount.rawValue] as? Int)
            
            self?.dataBase
                .collection("users")
                .document(friendUid).collection("friends")
                .document(currentUser.uid)
                .updateData(["totalAccount": 0])
        })
        
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
        
        print("=============")
        print(billingUid)
        
        NotificationCenter.default.post(name: NSNotification.Name("deleteBilling"), object: nil, userInfo: ["billingUid": billingUid])
        
        FirebaseManager.shared.deleteBilling(document: billingUid)
        FirebaseManager.shared.deleteFriendBilling(document: friendUid, billId: billingUid)
        
        dismiss(animated: true, completion: nil)
    }
    
}
