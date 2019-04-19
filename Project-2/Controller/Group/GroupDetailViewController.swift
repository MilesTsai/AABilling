//
//  GroupDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupDetailViewController: BaseViewController {

    @IBOutlet weak var groupDetailTableView: UITableView! {
        didSet {

            groupDetailTableView.dataSource = self

            groupDetailTableView.delegate = self

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {

        groupDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupDetailCell.self), bundle: nil)

        groupDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupAccountsListDetailCell.self), bundle: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func backGroupList(_ sender: UIButton) {

        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func groupSetting(_ sender: UIButton) {

        if let groupSettingVC =
            storyboard?.instantiateViewController(withIdentifier: "GroupSetting") {
            present(groupSettingVC, animated: true, completion: nil)
        }
    }

}

extension GroupDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupDetailCell.self))
        
        guard let groupHeaderCell = headerCell as? GroupDetailCell else { return headerCell }
        
        groupHeaderCell.groupSettleUp.addTarget(self, action: #selector(self.groupSettleUpSelect), for: .touchUpInside)
        return headerCell
        
    }
    
    @objc func groupSettleUpSelect() {
        
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        let settleVC =
            storyboard.instantiateViewController(
                withIdentifier: String(
                    describing: GroupSettleUpSelectViewController.self))
        present(settleVC, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupAccountsListDetailCell.self), for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let accountsDetailCell = cell as? GroupAccountsListDetailCell else { return cell }

        return accountsDetailCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension GroupDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
