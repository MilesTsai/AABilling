//
//  FriendDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendDetailViewController: BaseViewController {
    
    @IBOutlet weak var friendDetailTableView: UITableView! {
        
        didSet {
            
            friendDetailTableView.dataSource = self
            
            friendDetailTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        
        friendDetailTableView.mls_registerCellWithNib(identifier: String(describing: FriendDetailCell.self), bundle: nil)
        
        friendDetailTableView.mls_registerCellWithNib(identifier: String(describing: FriendAccountsListDetailCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backFriendList(_ sender: UIButton) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func friendSetting(_ sender: UIButton) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendSetting") {
            present(vc, animated: true, completion: nil)
        }
    }
    
}

extension FriendDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendDetailCell.self))
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendAccountsListDetailCell.self), for: indexPath)
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        guard let accountsDetailCell = cell as? FriendAccountsListDetailCell else { return cell }
        
        return accountsDetailCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "SegueFriendBillDetail", sender: nil)
    }
}

extension FriendDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
