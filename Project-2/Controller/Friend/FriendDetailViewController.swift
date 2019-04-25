//
//  FriendDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class FriendDetailViewController: BaseViewController {

    @IBOutlet weak var friendDetailTableView: UITableView! {

        didSet {

            friendDetailTableView.dataSource = self

            friendDetailTableView.delegate = self
        }
    }
    
    var dataBase: Firestore = Firestore.firestore()

    var friendData: PersonalData?
    
    var friendBill: BillData?
    
    var billingList = [BillData]()
    
    var settleUpList = [BillData]()
    
    var sum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteBillList(data:)), name: NSNotification.Name("deleteBilling"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(billList(data:)), name: NSNotification.Name("settleUp"), object: nil)

    }
    
    @objc func deleteBillList(data: Notification) {
        let billUid = data.userInfo?["billingUid"] as? String
        for (index, element) in billingList.enumerated() {
            if element.billUid == billUid {
                billingList.remove(at: index)
            }
            friendDetailTableView.reloadData()
        }
    }
    
    @objc func billList(data: Notification) {
        let billUid = data.userInfo?["billingUid"] as? String
        for (index, element) in billingList.enumerated() {
            if element.billUid == billUid {
                billingList.remove(at: index)
            }
            friendDetailTableView.reloadData()
        }
    }
    
    private func setupTableView() {

        friendDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: FriendDetailCell.self),
            bundle: nil
        )

        friendDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: FriendAccountsListDetailCell.self),
            bundle: nil
        )
    }
    
    func settleUp() {
        
        var tempSettleUp: [BillData] = []
        
        for settleUp in 0..<billingList.count {
            
            if billingList[settleUp].status != 2 {
                
                tempSettleUp.append(billingList[settleUp])
                
            }
            
            settleUpList = tempSettleUp
        }
    }
    
    private func billingDetail() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let friendUid = friendData?.uid else { return }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .collection("bills")
            .whereField("uid", isEqualTo: friendUid)
            .getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    guard let snap = snapshot else { return }
                    for document in snap.documents {
                        print("==========")
                        print(document.data())
                        
                        let billDetail = document.data()
                        
                        self.friendBill =
                            BillData(
                                uid: billDetail["uid"] as? String,
                                billUid: billDetail["billUid"] as? String,
                                name: billDetail["name"] as? String,
                                billName: billDetail["email"] as? String,
                                amountTotal: billDetail["status"] as? Int,
                                owedAmount: billDetail["amountTotal"] as? Int,
                                payAmount: billDetail["owedAmount"] as? Int,
                                status: billDetail["payAmount"] as? Int
                            )
                        }
                    
                    self.billingList =
                        snap
                            .documents
                            .compactMap({
                                BillData(dictionary: $0.data())
                            })
                    
                    self.settleUp()
                    
                    DispatchQueue.main.async {
                        
                        self.friendDetailTableView.reloadData()
                    }
                    
                }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        billingDetail()
        
        friendDetailTableView.reloadData()
    }

    @IBAction func backFriendList(_ sender: UIButton) {

        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func friendSetting(_ sender: UIButton) {
        
        guard let nextVC =
                    storyboard?.instantiateViewController(
                        withIdentifier: "FriendSetting")
                        as? UINavigationController else { return }
        
        guard let friendSettingVC =
                    nextVC.topViewController as? FriendSettingViewController else { return }
  
        friendSettingVC.friendDetailData = friendData
        present(nextVC, animated: true, completion: nil)
//        performSegue(withIdentifier: "SegueFriendSetting", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SegueFriendSetting" {
//            guard let friendSettingVC =
//                segue.destination
//                    as? UINavigationController else {
//                        return
//            }
//            guard let nextVC = friendSettingVC.children[0] as? FriendSettingViewController else {return}
//            nextVC.friendDetailData = friendData
//        }
//    }
}

extension FriendDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendDetailCell.self)
                )
        
        guard let friendHeaderCell =
                    headerCell as? FriendDetailCell else { return headerCell }
        
//        friendHeaderCell.settleUpBtn.addTarget(
//            self, action: #selector(self.friendSettleUp),
//            for: .touchUpInside
//        )
        
        friendHeaderCell.friendName.text = friendData?.name
        
        guard let friendName = friendBill?.name else { return friendHeaderCell }
        
        if sum > 0 {
            
            friendHeaderCell.friendBill.text =
            "\(friendName) 需還你 $\(sum)"
            
        } else if sum < 0 {
            
            sum.negate()
            
            friendHeaderCell.friendBill.text =
            "你 需還\(friendName) $\(sum)"
        }
        
        return friendHeaderCell
    }
    
//    @objc func friendSettleUp() {
//
//        let storyboard = UIStoryboard(name: "Friend", bundle: nil)
//        let settleVC =
//                storyboard.instantiateViewController(
//                    withIdentifier: String(
//                    describing: FriendSettleUpViewController.self)
//                )
//            present(settleVC, animated: true, completion: nil)
//
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settleUpList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendAccountsListDetailCell.self),
                for: indexPath
                )

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let accountsDetailCell =
                    cell as? FriendAccountsListDetailCell else { return cell }
        
        if settleUpList.count == 0 {
            
            return accountsDetailCell
            
        } else {
            
            let list = settleUpList[indexPath.row]
            
            guard var moneyList = list.owedAmount else { return accountsDetailCell }
            
            for totals in moneyList...moneyList {
                sum += totals
            }
            
            accountsDetailCell.billName.text = list.billName
            
            accountsDetailCell.sumOfMoney.text = "$\(moneyList)"
            
            accountsDetailCell.sumOfMoneyStatus.text = ""
            
            if moneyList > 0 {
                
                accountsDetailCell.sumOfMoneyStatus.text = "未取款"
                
                accountsDetailCell.sumOfMoney.text = "$\(String(describing: moneyList))"
                
            } else if moneyList < 0 {
                
                accountsDetailCell.sumOfMoneyStatus.text = "欠款"
                
                moneyList.negate()
                
                accountsDetailCell.sumOfMoney.text = "$\(String(describing: moneyList))"
            }
        }
        
        return accountsDetailCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "SegueFriendBillDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFriendBillDetail" {
            if let indexPath = friendDetailTableView.indexPathForSelectedRow {
                guard let friendBillDetailNC = segue.destination as? UINavigationController else { return }
                
                guard let friendBillDetailVC = friendBillDetailNC.topViewController as? FriendBillDetailViewController else { return }
                
                friendBillDetailVC.billingDetailData = settleUpList[indexPath.row]
            }
        }
    }
}

extension FriendDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 190
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
