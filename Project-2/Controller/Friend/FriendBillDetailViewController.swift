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
            myAccountStatus.text = "你付了 $\(pay)，並需回款 $\(owe)"
            friendAccountStatus.text = "\(friendName) 欠你 $\(owe)"
        } else if owe < 0 {
            owe.negate()
            myAccountStatus.text = "你欠 \(friendName) $\(owe)"
            friendAccountStatus.text = "\(friendName)付了 $\(money - pay)，並需回款 $\(owe)"
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
