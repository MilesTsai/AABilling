//
//  GroupSettingViewController.swift
//  Project-2
//
//  Created by User on 2019/4/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupSettingViewController: BaseViewController {

    @IBOutlet weak var groupSettingTableView: UITableView! {
        didSet {

            groupSettingTableView.dataSource = self

            groupSettingTableView.delegate = self

            groupSettingTableView.separatorStyle = .none
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {

        groupSettingTableView.mls_registerCellWithNib(identifier: String(describing: GroupHeaderCell.self), bundle: nil)

        groupSettingTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupSettingCell.self),
            bundle: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func cancelGroupSetting(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGroupMember(_ sender: UIButton) {
        
        performSegue(withIdentifier: "SegueAddGroupMember", sender: nil)
    }
    
}

extension GroupSettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupHeaderCell.self))
        return headerCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupSettingCell.self), for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView

        guard let groupSettingCell = cell as? GroupSettingCell else { return cell }
        
        return groupSettingCell
    }

}

extension GroupSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
