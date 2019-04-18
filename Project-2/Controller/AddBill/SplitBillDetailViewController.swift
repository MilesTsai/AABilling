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
        
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
//        guard let currentUser = Auth.auth().currentUser else { return }
//
//        if accountObject.text?.isEmpty == true
//            || friendBillName.text?.isEmpty == true
//            || billAmount.text?.isEmpty == true {
//
//            let alertController =
//                UIAlertController(
//                    title: "錯誤",
//                    message: "請輸入帳單資訊",
//                    preferredStyle: .alert
//            )
//            let defaultAction =
//                UIAlertAction(
//                    title: "OK",
//                    style: .cancel,
//                    handler: nil
//            )
//            alertController.addAction(defaultAction)
//
//            self.present(alertController, animated: true, completion: nil)
//
//        } else {
//            dataBase
//                .collection("users")
//                .whereField("name", isEqualTo: accountObject.text ?? "")
//                .getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print("Error getting documents: \(error)")
//                    } else {
//                        if querySnapshot?.isEmpty == true {
//                            print("No exist")
//                            let alertController =
//                                UIAlertController(
//                                    title: "錯誤",
//                                    message: "無此帳號",
//                                    preferredStyle: .alert
//                            )
//
//                            let defaultAction =
//                                UIAlertAction(
//                                    title: "OK",
//                                    style: .cancel,
//                                    handler: nil
//                            )
//
//                            alertController.addAction(defaultAction)
//
//                            self.present(alertController, animated: true, completion: nil)
//                        } else {
//                            for document in querySnapshot!.documents {
//                                print("\(document.documentID) => \(document.data())")
//
//                                self.friendID = String(document.documentID)
//
//                                let friend = document.data()
//
//                                self.bill =
//                                    BillData(
//                                        name: friend["name"] as? String,
//                                        billName: friend["billName"] as? String,
//                                        amount: friend["amount"] as? Int,
//                                        status: friend["status"] as? Int,
//                                        uid: friend["uid"] as? String
//                                )
//                            }
//                            self.addDocument(document: self.friendID ?? "")
//
//                            self.dataBase
//                                .collection("users")
//                                .document(currentUser.uid)
//                                .collection("bills")
//                                .addDocument(data:
//                                    [
//                                        BillData.CodingKeys.status.rawValue:
//                                        0,
//                                        BillData.CodingKeys.name.rawValue:
//                                            self.accountObject.text ?? "",
//                                        BillData.CodingKeys.billName.rawValue:
//                                            self.friendBillName.text ?? "",
//                                        BillData.CodingKeys.amount.rawValue:
//                                            self.billAmount.text ?? "",
//                                        BillData.CodingKeys.uid.rawValue:
//                                            self.friendID ?? ""
//                                    ])
//
//                            let alertController =
//                                UIAlertController(
//                                    title: "成功",
//                                    message: "帳單已成立",
//                                    preferredStyle: .alert
//                            )
//
//                            let defaultAction =
//                                UIAlertAction(
//                                    title: "OK",
//                                    style: .cancel,
//                                    handler: nil
//                            )
//
//                            alertController.addAction(defaultAction)
//
//                            self.present(alertController, animated: true, completion: nil)
//                        }
//                    }
                    //            dataBase
                    //                .collection("users")
                    //                .document(currentUser.uid)
                    //                .collection("bills")
                    //                .addDocument(data:
                    //                    [
                    //                        BillData.CodingKeys.name.rawValue:
                    //                            accountObject.text ?? "",
                    //                        BillData.CodingKeys.billName.rawValue:
                    //                            friendBillName.text ?? "",
                    //                        BillData.CodingKeys.amount.rawValue:
                    //                            Int(billAmount.text ?? "") ?? "",
                    //                        BillData.CodingKeys.status.rawValue: 0
                    //                ]) { error in
                    //                    if let error = error {
                    //                        print("Error adding document: \(error)")
                    //                    } else {
                    //                        let alertController =
                    //                            UIAlertController(
                    //                                title: "成功",
                    //                                message: "帳單已成立",
                    //                                preferredStyle: .alert
                    //                            )
                    //
                    //                        let defaultAction =
                    //                            UIAlertAction(
                    //                                title: "OK",
                    //                                style: .cancel,
                    //                                handler: nil
                    //                            )
                    //
                    //                        alertController.addAction(defaultAction)
                    //
                    //                        self.present(alertController, animated: true, completion: nil)
                    //
                    //                        self.dataBase.collection("users").addSnapshotListener({ (snapshot, _) in
                    //
                    //                        guard let snapshot = snapshot else { return }
                    //
                    //                        for document in snapshot.documents {
                    //                                print("\(document.documentID) => \(document.data())")
                    //
                    //                            self.friendID = String(document.documentID)
                    //                            }
                    //                        })
                    //                    }
                    //                    self.addDocument(document: self.friendID ?? "")
//            }
//        }
//    }
    
//    private func addDocument(document: String) {
//        //        friendID = Friend.friendList[0].uid
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
