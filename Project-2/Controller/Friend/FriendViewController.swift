//
//  FriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: FriendTableViewCell.self),
            bundle: nil
        )
    }
    
    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddFriend") {
            present(vc, animated: true, completion: nil)
        }
    }
}



extension FriendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendTableViewCell.self), for: indexPath)
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        guard let friendCell = cell as? FriendTableViewCell else { return cell }
        
        return friendCell
    }
    
    
}

extension FriendViewController: UITableViewDelegate {
    
}
