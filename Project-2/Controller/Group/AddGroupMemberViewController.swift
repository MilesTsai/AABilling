//
//  AddGroupMemberViewController.swift
//  Project-2
//
//  Created by User on 2019/4/10.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddGroupMemberViewController: UIViewController {
    
    @IBOutlet weak var addGroupMemberTableView: UITableView! {
        didSet {
            
            addGroupMemberTableView.dataSource = self
            
            addGroupMemberTableView.delegate = self
            
            addGroupMemberTableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        
        addGroupMemberTableView.mls_registerCellWithNib(
            identifier: String(describing: AddGroupMemberHeaderCell.self), bundle: nil)
        
        addGroupMemberTableView.mls_registerCellWithNib(
            identifier: String(describing: AddGroupMemberCell.self), bundle: nil)
    }
}

extension AddGroupMemberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddGroupMemberHeaderCell.self))
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddGroupMemberCell.self), for: indexPath)
        
        guard let addGroupMemberCell = cell as? AddGroupMemberCell else { return cell }
        return addGroupMemberCell
    }
    
}

extension AddGroupMemberViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
