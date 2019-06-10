//
//  FriendDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class FriendDetailViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var friendDetailTableView: UITableView! {

        didSet {
            friendDetailTableView.dataSource = self
            friendDetailTableView.delegate = self
            friendDetailTableView.separatorStyle = .none
        }
    }

    var friendData: PersonalData?
    
    var friendBill: BillData?
    
    var billingList = [BillData]()
    
    var sum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteBillList(data:)),
            name: NSNotification.Name("deleteBilling"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(billList(data:)),
            name: NSNotification.Name("settleUp"),
            object: nil
        )
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
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
        friendDetailTableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.billingDetail()
        })
    }
    
    func lentAmount() {

        var lent = 0

        for owed in billingList {
            
            guard let owedTotal = owed.owedAmount else { return }
            
            lent += owedTotal
        }
        sum = lent
    }
    
    func billingDetail() {
        
        guard let friendID = friendData?.uid else { return }
        
        FirebaseManager.shared.readBillingDetail(friendUid: friendID, completion: { [weak self] (billingList) in
            
            self?.billingList = billingList
            self?.lentAmount()
            
            DispatchQueue.main.async {
                
                self?.friendDetailTableView.reloadData()
                self?.friendDetailTableView.mj_header.endRefreshing()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        billingDetail()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)

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
    }
}

extension FriendDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendDetailCell.self)
                )
        
        guard let friendHeaderCell =
                    headerCell as? FriendDetailCell else { return headerCell }
        
        friendHeaderCell
            .friendBackgroundColor
            .setGradientBackground(
                colorTop: #colorLiteral(red: 0.3777077794, green: 0.7216741443, blue: 0.5373740196, alpha: 1),
                colorBottom: #colorLiteral(red: 0.3777077794, green: 0.7216741443, blue: 0.5373740196, alpha: 1),
                startPoint: CGPoint(x: 0.5, y: 1.0),
                endPoint: CGPoint(x: 0.5, y: 0.0)
        )
        
        friendHeaderCell.friendName.text = friendData?.name
        
        guard let friendName = friendBill?.name else { return friendHeaderCell }
        
        if sum > 0 {
            
            friendHeaderCell.friendBill.text =
            "\(friendName) 需還你 $\(sum)"

        } else if sum < 0 {
            
            sum.negate()
            friendHeaderCell.friendBill.text =
            "你 需還\(friendName) $\(sum)"
            
        } else if sum == 0 {
            
            friendHeaderCell.friendBill.text = "積欠金額為 $0"
        }
        
        return friendHeaderCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return billingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendAccountsListDetailCell.self),
                for: indexPath
                )

        guard let accountsDetailCell =
                    cell as? FriendAccountsListDetailCell else { return cell }
        if billingList.count == 0 {
            
            return accountsDetailCell
            
        } else {
            
            let list = billingList[indexPath.row]
            
            guard var moneyList = list.owedAmount else { return accountsDetailCell }
            
            accountsDetailCell.billName.text = list.billName
            accountsDetailCell.sumOfMoney.text = "$\(moneyList)"
            accountsDetailCell.sumOfMoneyStatus.text = ""
                
            if moneyList > 0 {
                    
                accountsDetailCell.sumOfMoneyStatus.text = "借出"
                accountsDetailCell.sumOfMoney.text = "$\(String(describing: moneyList))"
                accountsDetailCell.sumOfMoneyStatus.textColor = .init(cgColor: #colorLiteral(red: 0.2470588235, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
                    
            } else if moneyList < 0 {
                    
                accountsDetailCell.sumOfMoneyStatus.text = "欠款"
                accountsDetailCell.sumOfMoneyStatus.textColor = .red
                moneyList.negate()
                accountsDetailCell.sumOfMoney.text = "$\(String(describing: moneyList))"
                
            } else if moneyList == 0 {
                
                accountsDetailCell.sumOfMoneyStatus.text = "銀貨兩訖"
                accountsDetailCell.sumOfMoney.text = "$0"
                accountsDetailCell.sumOfMoneyStatus.textColor = .init(cgColor: #colorLiteral(red: 0.2470588235, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
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
                
                guard let friendBillDetailVC =
                    friendBillDetailNC.topViewController as? FriendBillDetailViewController else { return }
                
                friendBillDetailVC.billingDetailData = billingList[indexPath.row]
            }
        }
    }
}

extension FriendDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 190 + UIApplication.shared.statusBarFrame.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
