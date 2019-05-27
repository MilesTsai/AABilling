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
    
    var equalViewController: EqualViewController?
    
    var individualViewController: IndividualViewController?
    
    var friendBillingUid: ((String) -> Void)?
    
    var friendID: String?
    
    var myFriend: [String: Any]?
    
    var friendBillData: [String: Any]?
    
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
    
//    @IBOutlet weak var payer: UILabel!
    
    var containerViews: [UIView] {
        
        return [equalContainerView, individualContainerView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        equalViewController?.owedAmount = { [weak self] calculation in
            self?.equalCalculationResult = calculation
        }
        
        equalViewController?.payAmount = { [weak self] whoPay in
            self?.equalResult = whoPay
        }
        
        equalViewController?.friendOwedAmount = { [weak self] calculation in
            self?.friendEqualCalculationResult = calculation
        }
        
        equalViewController?.friendPayAmount = { [weak self] whoPay in
            self?.friendEqualResult = whoPay
        }
        
        individualViewController?.owedAmount = { [weak self] calculation in
            
            if calculation == Int(-0.9501) {
                
                self?.individualResult = nil
                
                self?.friendIndividualResult = nil
            }
            
            self?.individualCalculationResult = calculation
        }
        
        individualViewController?.payAmount = { [weak self] whoPay in
            
            self?.individualResult = whoPay
        }
        
        individualViewController?.friendOwedAmount = { [weak self] calculation in
            
            self?.friendIndividualCalculationResult = calculation
        }
        
        individualViewController?.friendPayAmount = { [weak self] whoPay in
            
            self?.friendIndividualResult = whoPay
        }
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
        if selectExpenseBtns[0].isSelected == true {
            
            if billingContent!.amount + 1 == equalCalculationResult {
                
                AlertManager().alertView(title: "錯誤", message: "請至少選擇一人", view: self)
                
            } else {
                
                if equalCalculationResult! < 0 {
                    amountStatus = 1
                } else if equalCalculationResult == 0 {
                    amountStatus = 2
                } else if equalCalculationResult! > 0 {
                    amountStatus = 0
                }
                
                let billData = BillData(
                    uid: friendID ?? "",
                    billUid: nil,
                    name: billingContent?.anyone ?? "",
                    billName: billingContent?.billName ?? "",
                    amountTotal: billingContent?.amount ?? 0,
                    owedAmount: equalCalculationResult ?? 0,
                    payAmount: equalResult ?? 0,
                    status: amountStatus ?? 3
                )
                
                FirebaseManager.shared.createMyBilling(billData: billData) { [weak self] (billUid) in
                    self?.addEqualDocument(billUid: billUid)
                }
                
                updateEqualDocument()
                
                let alertController =
                    UIAlertController(
                        title: "成功",
                        message: "帳單已成立",
                        preferredStyle: .alert
                )
                
                let defaultAction =
                    UIAlertAction(
                        title: "OK",
                        style: .cancel,
                        handler: { [weak self] _ in
                        self?.presentingViewController?.dismiss(
                            animated: true, completion: nil)
                    })
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)}
            
        } else {
            
            guard let indvidualSum = individualResult else {
                
                AlertManager().alertView(title: "錯誤", message: "請輸入金額", view: self)
                
                return }
            
            guard let amountTotal = billingContent?.amount else { return }
            
            if Int(-0.9501) == individualCalculationResult {
                
                AlertManager().alertView(
                    title: "錯誤",
                    message: "請輸入金額",
                    view: self
                )
                
            } else if indvidualSum < 0 || indvidualSum > amountTotal {
                
                AlertManager().alertView(
                    title: "錯誤",
                    message: "超出輸入金額範圍",
                    view: self
                )
                
            } else {
            
                if individualCalculationResult! < 0 {
                    amountStatus = 1
                } else if individualCalculationResult == 0 {
                    amountStatus = 2
                } else if individualCalculationResult! > 0 {
                    amountStatus = 0
                }
                
                let billData = BillData(
                    uid: friendID ?? "",
                    billUid: nil,
                    name: billingContent?.anyone ?? "",
                    billName: billingContent?.billName ?? "",
                    amountTotal: billingContent?.amount ?? 0,
                    owedAmount: individualCalculationResult ?? 0,
                    payAmount: individualResult ?? 0,
                    status: amountStatus ?? 3
                )
                
                FirebaseManager.shared.createMyBilling(billData: billData) { [weak self] (billUid) in
                    self?.addIndividualDocument(billUid: billUid)
                }
                
                updateIndividualDocument()
                
                let alertController =
                    UIAlertController(
                        title: "成功",
                        message: "帳單已成立",
                        preferredStyle: .alert
                )
                
                let defaultAction =
                    UIAlertAction(
                        title: "OK",
                        style: .cancel,
                        handler: { [weak self] _ in
                        self?.presentingViewController?.dismiss(
                            animated: true, completion: nil)
                    })
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func addEqualDocument(billUid: String) {
        
        if friendEqualCalculationResult! < 0 {
            amountStatus = 1
        } else if friendEqualCalculationResult == 0 {
            amountStatus = 2
        } else if friendEqualCalculationResult! > 0 {
            amountStatus = 0
        }
        
        FirebaseManager.shared.createFriendBilling(
            friendID: self.friendID ?? "",
            billName: self.billingContent?.billName ?? "",
            amountTotal: self.billingContent?.amount ?? 0,
            owedAmount: self.friendEqualCalculationResult ?? 0,
            payAmount: self.friendEqualResult ?? 0,
            status: self.amountStatus ?? 3,
            billUid: billUid)
    }
    
    private func addIndividualDocument(billUid: String) {
        
        if friendIndividualCalculationResult! < 0 {
            amountStatus = 1
        } else if friendIndividualCalculationResult == 0 {
            amountStatus = 2
        } else if friendIndividualCalculationResult! > 0 {
            amountStatus = 0
        }
        
        FirebaseManager.shared.createFriendBilling(
            friendID: self.friendID ?? "",
            billName: self.billingContent?.billName ?? "",
            amountTotal: self.billingContent?.amount ?? 0,
            owedAmount: self.friendIndividualCalculationResult ?? 0,
            payAmount: self.friendIndividualResult ?? 0,
            status: self.amountStatus ?? 3,
            billUid: billUid)
    }
    
    private func updateEqualDocument() {
        
        guard let equal = equalCalculationResult else { return }
        
        guard let friendEqual = friendEqualCalculationResult else { return }
        
        guard let money = (myFriend?["totalAccount"]) as? Int else { return }
        
        guard let friendMoney = (friendBillData?["totalAccount"]) as? Int else { return }
        
        let equalSum = money + equal
        
        let friendEqualSum = friendMoney + friendEqual
        
        FirebaseManager.shared.updateMySum(friendID: friendID ?? "", sum: equalSum)
        FirebaseManager.shared.updateFriendSum(friendID: friendID ?? "", friendSum: friendEqualSum)
    }
    
    private func updateIndividualDocument() {
        
        guard let individual = individualCalculationResult else { return }
        
        guard let friendIndividual = friendIndividualCalculationResult else { return }
        
        guard let amount = (myFriend?["totalAccount"]) as? Int else { return }
        
        guard let friendAmount = (friendBillData?["totalAccount"]) as? Int else { return }
        
        let individualSum = amount + individual
        
        let friendIndividualSum = friendAmount + friendIndividual
        
        FirebaseManager.shared.updateMySum(friendID: friendID ?? "", sum: individualSum)
        FirebaseManager.shared.updateFriendSum(friendID: friendID ?? "", friendSum: friendIndividualSum)
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
            equalViewController = equalVC
            equalViewController?.equalBilling = billingContent
            
        } else if identifier == Segue.individual {
            
            guard let individualVC = segue.destination as? IndividualViewController
                else {
                    return
            }
            individualViewController = individualVC
            individualViewController?.individualBilling = billingContent
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
        
        if number == 0 || number == 1 {
            
            selectExpenseBtns[number].isSelected = true
        }
        
        guard let type = ShareType(rawValue: number) else { return }

        updateContainer(type: type)
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
}
