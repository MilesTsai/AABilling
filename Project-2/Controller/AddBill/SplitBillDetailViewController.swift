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
    
    var dataBase: Firestore = Firestore.firestore()
    
    var friendID: String?
    
    var user: PersonalData?
    
    var bill: BillData?
    
    var billingContent: BillingContent?
    
    var equalCalculationResult: Int?
    
    var equalResult: Int?
    
    var individualCalculationResult: Int?
    
    var individualResult: Int?
    
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
        
        vc1?.selectHandler = { [weak self] name in
            self?.payer.text = name
        }
        
        vc2?.selectHandler = { [weak self] name in
            self?.payer.text = name
        }
        
        vc1?.shareAmount = { [weak self] calculation in
            self?.equalCalculationResult = calculation
        }
        
        vc1?.payAmount = { [weak self] whoPay in
            self?.equalResult = whoPay
        }
        
        vc2?.shareAmount = { [weak self] calculation in
            self?.individualCalculationResult = calculation
        }
        
        vc2?.payAmount = { [weak self] whoPay in
            self?.individualResult = whoPay
        }
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        if selectExpenseBtns[0].isSelected == true {
            
            if billingContent!.amount + 1 == equalCalculationResult {
                
                let alertController =
                    UIAlertController(
                        title: "錯誤",
                        message: "請至少選擇一人",
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
                
                if equalCalculationResult! < 0 {
                    amountStatus = 1
                } else if equalCalculationResult == 0 {
                    amountStatus = 2
                } else if equalCalculationResult! > 0 {
                    amountStatus = 0
                }
                
                dataBase
                    .collection("users")
                    .document(currentUser.uid)
                    .collection("bills")
                    .document()
                    .setData(
                        [
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
                                amountStatus ?? ""
                        ]
                )
                
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
                        handler: nil
                )
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else if selectExpenseBtns[1].isSelected == true {
            
            if billingContent!.amount - billingContent!.amount + Int(0.01) == individualCalculationResult {

                let alertController =
                    UIAlertController(
                        title: "錯誤",
                        message: "請填入金額",
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
            
                if individualCalculationResult! < 0 {
                    amountStatus = 1
                } else if individualCalculationResult == 0 {
                    amountStatus = 2
                } else if individualCalculationResult! > 0 {
                    amountStatus = 0
                }
                
                dataBase
                    .collection("users")
                    .document(currentUser.uid)
                    .collection("bills")
                    .document()
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
                                amountStatus ?? ""
                        ]
                )
                
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
                        handler: nil
                )
                
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
//    private func addDocument(document: String) {
//        guard let currentUser = Auth.auth().currentUser else { return }
//
//        dataBase
//            .collection("users")
//            .document(friendID ?? "")
//            .collection("bills")
//            .addDocument(data:
//                [
//                    BillData.CodingKeys.name.rawValue: accountObject.text ?? "",
//                    BillData.CodingKeys.billName.rawValue: friendBillName.text ?? "",
//                    BillData.CodingKeys.amount.rawValue: Int(billAmount.text ?? "") ?? "",
//                    BillData.CodingKeys.uid.rawValue: currentUser.uid,
//                    BillData.CodingKeys.status.rawValue: 1
//                ])
//    }
    
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
