//
//  IndividualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class MoneyShare: NSObject {
    
    @objc dynamic var userMoney = Int()
    @objc dynamic var friendMoney = Int()
}

class IndividualViewController: BaseTableViewController {
    
    var individualBilling: BillingContent?
    
    var dataBase: Firestore = Firestore.firestore()
    
    var userNameInfo: String = ""
    
    var myAmount: Int?
    
    var friendAmount: Int?
    
    var moneyShareKVO = MoneyShare()
    
    var moneyValue: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .getDocument { [weak self](snapshot, _) in
                
            guard let document = snapshot?.data()
                else {
                    return
                }
                
            self?.userNameInfo = document["name"] as? String ?? "No Document"
            print(self?.userNameInfo ?? "")
            self?.tableView.reloadData()
        }
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        moneyValue = moneyShareKVO.observe(\.userMoney, options:[.new]) { (object, change) in
            self.moneyShareKVO.friendMoney = change.newValue!
            self.tableView.reloadData()
        }
        
        moneyValue = moneyShareKVO.observe(\.friendMoney, options:[.initial, .new]) { (object, change) in
            self.moneyShareKVO.userMoney = change.newValue!
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: IndividualCell.self),
            bundle: nil
        )
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            
        return 2
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let myCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: IndividualCell.self),
                for: indexPath
            )
            
            guard let individualCell = myCell as? IndividualCell
                else {
                    return myCell
            }
            
            individualCell.userName.text = userNameInfo
            
            guard let amount = Int(individualCell.amount.text ?? "")
                else {
                    return individualCell
            }
            myAmount = amount
            moneyShareKVO.friendMoney = amount
            
            return individualCell
            
        case 1:
            let friendCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: IndividualCell.self),
                for: indexPath
            )
            
            guard let individualCell =
                friendCell as? IndividualCell
                else {
                    return friendCell
            }
            
            individualCell.userName.text = individualBilling?.anyone
            
            guard let amount = Int(individualCell.amount.text ?? "")
                else {
                    return individualCell
            }
            friendAmount = amount
            moneyShareKVO.userMoney = amount
            
            return individualCell
        
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            
        return 60
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
