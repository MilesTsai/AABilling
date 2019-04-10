//
//  GroupBillDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/10.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupBillDetailViewController: UIViewController {
    
    @IBOutlet weak var groupBillDetailTableView: UITableView! {
        didSet {
            
//            groupBillDetailTableView.dataSource = self
//
//            groupBillDetailTableView.delegate = self
            
            groupBillDetailTableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {
        
        groupBillDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupBillDetailTitleCell.self), bundle: nil)
        
        groupBillDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupBillDetailCell.self), bundle: nil)
    }
}
//
//extension GroupBillDetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
//
//extension GroupBillDetailViewController: UITableViewDelegate {
//
//}
