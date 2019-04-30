//
//  SplitBillDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class SplitBillDetailViewController: BaseViewController {
    
    var vc1: EqualViewController?
    
    var vc2: IndividualViewController?
    
    var friendBillingUid: ((String) -> Void)?
    
    var dataBase: Firestore = Firestore.firestore()
    
    var friendID: String?
    
    var myFriend: [String: Any]?
    
    var friendBillData: [String: Any]?
    
    var userData: UserData?
    
    var bill: BillData?
    
    var billingContent: BillingContent?
    
    var equalCalculationResult: Int?
    
    var equalResult: Int?
    
    var friendEqualCalculationResult: Int?
    
    var friendEqualResult: Int?
    
    var individualCalculationResult: Int?
    
    var individualResult: Int?
    
    var friendIndividualCalculationResult: Int?
    
    var friendIndividualResult: Int?
    
    var amountStatus: Int?
    
    private enum ShareType: Int {
        
        case equal = 0
        
        case individual = 1
    }
    
    private struct Segue {
        
        static let equal = "SegueEqual"
        
        static let individual = "SegueIndividual"
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var equalContainerView: UIView!
    
    @IBOutlet weak var individualContainerView: UIView!
    
    @IBOutlet var selectExpenseBtns: [UIButton]!
    
    @IBOutlet weak var payer: UILabel!
    
    var containerViews: [UIView] {
        
        return [equalContainerView, individualContainerView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        vc1?.selectHandler = { [weak self] name in
//            self?.payer.text = name
//        }
//        
//        vc2?.selectHandler = { [weak self] name in
//            self?.payer.text = name
//        }
        
        vc1?.owedAmount = { [weak self] calculation in
        
            
            
            self?.equalCalculationResult = calculation
        }
        
        vc1?.payAmount = { [weak self] whoPay in
            self?.equalResult = whoPay
        }
        
        vc1?.friendOwedAmount = { [weak self] calculation in
            self?.friendEqualCalculationResult = calculation
        }
        
        vc1?.friendPayAmount = { [weak self] whoPay in
            self?.friendEqualResult = whoPay
        }
        
        vc2?.owedAmount = { [weak self] calculation in
            
            if calculation == Int(-0.9501) {
                
                self?.individualResult = nil
                
                self?.friendIndividualResult = nil
                
            }
            
            self?.individualCalculationResult = calculation
        }
        
        vc2?.payAmount = { [weak self] whoPay in
            
            self?.individualResult = whoPay
        }
        
        vc2?.friendOwedAmount = { [weak self] calculation in
            
            self?.friendIndividualCalculationResult = calculation
        }
        
        vc2?.friendPayAmount = { [weak self] whoPay in
            
            self?.friendIndividualResult = whoPay
        }
        
        print("=========")
        print(myFriend)
        
        print("=========")
        print(friendBillData)
        
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
        guard let currentUser = Auth.auth().currentUser
            else { return }
        
        if selectExpenseBtns[0].isSelected == true {
            
            if billingContent!.amount + 1 == equalCalculationResult {
                
                let alertController =
                    UIAlertController(title: "錯誤", message: "請至少選擇一人", preferredStyle: .alert)
                
                let defaultAction =
                    UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                if equalCalculationResult! < 0 {
                    amountStatus = 1
                } else if equalCalculationResult == 0 {
                    amountStatus = 2
                } else if equalCalculationResult! > 0 {
                    amountStatus = 0
                }
                let ref = dataBase.collection("users").document()
                let refUid = ref.documentID
                
                dataBase
                    .collection("users")
                    .document(currentUser.uid)
                    .collection("bills")
                    .document(refUid)
                    .setData([
                            BillData.CodingKeys.name.rawValue:
                                billingContent?.anyone ?? "",
                            BillData.CodingKeys.billName.rawValue:
                                billingContent?.billName ?? "",
                            BillData.CodingKeys.amountTotal.rawValue:
                                billingContent?.amount ?? "",
                            BillData.CodingKeys.owedAmount.rawValue:
                                equalCalculationResult ?? "",
                            BillData.CodingKeys.payAmount.rawValue:
                                equalResult ?? "",
                            BillData.CodingKeys.status.rawValue:
                                amountStatus ?? "",
                            BillData.CodingKeys.uid.rawValue: friendID ?? "",
                            BillData.CodingKeys.billUid.rawValue: refUid])
                addEqualDocument(document: refUid)
                updateEqualDocument()
                
                let alertController =
                    UIAlertController(title: "成功", message: "帳單已成立", preferredStyle: .alert)
                
                let defaultAction =
                    UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                        self?.presentingViewController?.dismiss(animated: true, completion: nil)})
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)}
            
        } else {
            
            guard let indvidualSum = individualResult else {
                
                AlertManager().alertView(title: "錯誤", message: "請輸入金額", view: self)
                
                return }
            
            guard let amountTotal = billingContent?.amount else { return }
            
            if Int(-0.9501) == individualCalculationResult {
                
                AlertManager().alertView(title: "錯誤", message: "請填入金額", view: self)
                
            } else if indvidualSum < 0 || indvidualSum > amountTotal {
                
                AlertManager().alertView(title: "錯誤", message: "超出輸入金額範圍", view: self)
                
            } else {
            
                if individualCalculationResult! < 0 {
                    amountStatus = 1
                } else if individualCalculationResult == 0 {
                    amountStatus = 2
                } else if individualCalculationResult! > 0 {
                    amountStatus = 0
                }
                
                let ref = dataBase.collection("users").document()
                let refUid = ref.documentID
                
                dataBase
                    .collection("users")
                    .document(currentUser.uid)
                    .collection("bills")
                    .document(refUid)
                    .setData(
                        [
                            BillData.CodingKeys.name.rawValue:
                                billingContent?.anyone ?? "",
                            BillData.CodingKeys.billName.rawValue:
                                billingContent?.billName ?? "",
                            BillData.CodingKeys.amountTotal.rawValue:
                                billingContent?.amount ?? "",
                            BillData.CodingKeys.owedAmount.rawValue:
                                individualCalculationResult ?? "",
                            BillData.CodingKeys.payAmount.rawValue:
                                individualResult ?? "",
                            BillData.CodingKeys.status.rawValue:
                                amountStatus ?? "",
                            BillData.CodingKeys.uid.rawValue: friendID ?? "",
                            BillData.CodingKeys.billUid.rawValue: refUid])
                addIndividualDocument(document: refUid)
                updateIndividualDocument()
                
                let alertController =
                    UIAlertController(title: "成功", message: "帳單已成立", preferredStyle: .alert)
                
                let defaultAction =
                    UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                            self?.presentingViewController?.dismiss(animated: true, completion: nil)})
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func addEqualDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        if friendEqualCalculationResult! < 0 {
            amountStatus = 1
        } else if friendEqualCalculationResult == 0 {
            amountStatus = 2
        } else if friendEqualCalculationResult! > 0 {
            amountStatus = 0
        }
        dataBase.collection("users").document(currentUser.uid).getDocument(completion: { (snapshot, error) in
            let user = snapshot?.data()
            self.userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String)
        
            self.dataBase
            .collection("users")
            .document(self.friendID ?? "")
            .collection("bills")
            .document(document)
            .setData(
                [
                    BillData.CodingKeys.name.rawValue: self.userData?.name ?? "",
                    BillData.CodingKeys.billName.rawValue: self.billingContent?.billName ?? "",
                    BillData.CodingKeys.amountTotal.rawValue: self.billingContent?.amount ?? "",
                    BillData.CodingKeys.owedAmount.rawValue: self.friendEqualCalculationResult ?? "",
                    BillData.CodingKeys.payAmount.rawValue: self.friendEqualResult ?? "",
                    BillData.CodingKeys.status.rawValue: self.amountStatus ?? "",
                    BillData.CodingKeys.uid.rawValue: currentUser.uid,
                    BillData.CodingKeys.billUid.rawValue: document
                ]
            )
        })
    }
    
    private func addIndividualDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        if friendIndividualCalculationResult! < 0 {
            amountStatus = 1
        } else if friendIndividualCalculationResult == 0 {
            amountStatus = 2
        } else if friendIndividualCalculationResult! > 0 {
            amountStatus = 0
        }
        
        dataBase.collection("users").document(currentUser.uid).getDocument(completion: { (snapshot, error) in
            let user = snapshot?.data()
            self.userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String)
        
            self.dataBase
            .collection("users")
            .document(self.friendID ?? "")
            .collection("bills")
            .document(document)
            .setData(
                [
                    BillData.CodingKeys.name.rawValue: self.userData?.name ?? "",
                    BillData.CodingKeys.billName.rawValue: self.billingContent?.billName ?? "",
                    BillData.CodingKeys.amountTotal.rawValue: self.billingContent?.amount ?? "",
                    BillData.CodingKeys.owedAmount.rawValue: self.friendIndividualCalculationResult ?? "",
                    BillData.CodingKeys.payAmount.rawValue: self.friendIndividualResult ?? "",
                    BillData.CodingKeys.status.rawValue: self.amountStatus ?? "",
                    BillData.CodingKeys.uid.rawValue: currentUser.uid,
                    BillData.CodingKeys.billUid.rawValue: document
                ]
            )
        })
    }
    
    private func updateEqualDocument() {
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        guard let equal = equalCalculationResult else { return }
        
        guard let friendEqual = friendEqualCalculationResult else { return }
        
        guard let money = (myFriend?["totalAccount"]) as? Int else { return }
        
        guard let friendMoney = (friendBillData?["totalAccount"]) as? Int else { return }
        
        let equalSum = money + equal
        
        let friendEqualSum = friendMoney + friendEqual
        
        dataBase
            .collection("users")
            .document(currentUser.uid).collection("friends")
            .document(friendID ?? "")
            .updateData(["totalAccount": equalSum])
        
        dataBase
            .collection("users")
            .document(friendID ?? "").collection("friends")
            .document(currentUser.uid)
            .updateData(["totalAccount": friendEqualSum])
    }
    
    private func updateIndividualDocument() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let individual = individualCalculationResult else { return }
        
        guard let friendIndividual = friendIndividualCalculationResult else { return }
        
        guard let amount = (myFriend?["totalAccount"]) as? Int else { return }
        
        guard let friendAmount = (friendBillData?["totalAccount"]) as? Int else { return }
        
        let individualSum = amount + individual
        
        let friendIndividualSum = friendAmount + friendIndividual
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("friends")
            .document(friendID ?? "")
            .updateData(["totalAccount": individualSum])
        
        dataBase
            .collection("users")
            .document(friendID ?? "").collection("friends")
            .document(currentUser.uid)
            .updateData(["totalAccount": friendIndividualSum])
    }
    
    @IBAction func cancelExpenseDetail(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        
        for btn in selectExpenseBtns {
            
            btn.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(toPage: sender.tag)
        
        guard let type = ShareType(rawValue: sender.tag)
            else {
                return
        }
        updateContainer(type: type)
    }
    
    private func moveIndicatorView(toPage: Int) {
        
        indicatorLeadingConstraint.constant
            = CGFloat(toPage) * UIScreen.width / 2
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.scrollView.contentOffset.x
                = CGFloat(toPage) * UIScreen.width
            
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateContainer(type: ShareType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .equal:
            equalContainerView.isHidden = false
            
        case .individual:
            individualContainerView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifier = segue.identifier
        
        if identifier == Segue.equal {
            guard let equalVC = segue.destination as? EqualViewController
                else {
                    return
            }
            vc1 = equalVC
            vc1?.equalBilling = billingContent
            
        } else if identifier == Segue.individual {
            
            guard let individualVC = segue.destination as? IndividualViewController
                else {
                    return
            }
            vc2 = individualVC
            vc2?.individualBilling = billingContent
        }
    }
}

extension SplitBillDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorLeadingConstraint.constant
            = scrollView.contentOffset.x / 2
        
        let temp = Double(scrollView.contentOffset.x / UIScreen.width)
        
        let number = lround(temp)
        
        for btn in selectExpenseBtns {
            
            btn.isSelected = false
        }
        
        selectExpenseBtns[number].isSelected = true
        
        guard let type = ShareType(rawValue: number) else { return }

        updateContainer(type: type)
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
}
