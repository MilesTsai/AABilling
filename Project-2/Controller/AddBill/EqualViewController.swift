//
//  EqualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class EqualViewController: BaseTableViewController {
    
    var equalView: EqualCell?
    
    var averageView: AverageValueCell?
    
    var equalBilling: BillingContent?
    
    var dataBase: Firestore = Firestore.firestore()
    
    var userNameInfo: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }

        dataBase
            .collection("users")
            .document(currentUser.uid)
            .getDocument {
                [weak self](snapshot, error) in
                
            guard let document = snapshot?.data()
                else {
                    return
                }
                
            self?.userNameInfo =
                document["name"] as? String ?? "No Document"
            print(self?.userNameInfo ?? "")
            self?.tableView.reloadData()
        }

        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: EqualCell.self),
            bundle: nil
        )
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: AverageValueCell.self),
            bundle: nil
        )
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
        
        return 3
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

        switch indexPath.row {
            
        case 0:
            let myCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: EqualCell.self),
                for: indexPath
            )
            
            guard let equalCell = myCell as? EqualCell
                else {
                    return myCell
            }
            
            equalCell.userName.text = userNameInfo
            
            equalCell.paySelectBtn.addTarget(
                self,
                action: #selector(self.paySelect(_:)),
                for: .touchUpInside
            )
            
            return equalCell
            
        case 1:
            let friendCell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: EqualCell.self),
                    for: indexPath
            )
            
            guard let equalCell = friendCell as? EqualCell
                else {
                    return friendCell
            }
            
            equalCell.userName.text = equalBilling?.anyone
            
            equalCell.paySelectBtn.addTarget(
                self,
                action: #selector(self.paySelect(_:)),
                for: .touchUpInside
            )
            
            return equalCell
            
        case 2:
            let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: AverageValueCell.self),
                    for: indexPath
            )
            
            guard let averageCell = cell as? AverageValueCell
                else {
                    return cell
            }
            
            averageCell.averageValue.text = "$\(equalBilling!.amount / 2)/人"
            
            return averageCell
            
        default:
            
            return UITableViewCell()
        }
//        if indexPath.row == 0 {
//            let myCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EqualCell.self), for: indexPath)
//
//            guard let equalCell = myCell as? EqualCell else { return myCell }
//
//            return equalCell
//
//        } else if indexPath.row == 1 {
//            let friendCell =
//                tableView.dequeueReusableCell(withIdentifier: String(describing: EqualCell.self), for: indexPath)
//
//            guard let equalCell =
//                friendCell as? EqualCell else { return friendCell }
//
//            equalCell.userName.text = billingContent?.anyone
//
//            equalCell.paySelectBtn.addTarget(self, action: #selector(self.paySelect(_:)), for: .touchUpInside)
//
//            return equalCell
//        } else if indexPath.row == 2 {
//            let cell =
//                tableView.dequeueReusableCell(withIdentifier: String(describing: AverageValueCell.self), for: indexPath)
//
//            guard let averageCell = cell as? AverageValueCell else { return cell }
//
//            return averageCell
//        }
    }
    
    @objc func paySelect(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
