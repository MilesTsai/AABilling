//
//  GroupViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupViewController: BaseViewController {

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupTableView() {

        tableView.mls_registerCellWithNib(
            identifier: String(describing: GroupListCell.self),
            bundle: nil
        )
    }

    @IBAction func addGroup(_ sender: UIBarButtonItem) {
        if let addGroupVC = storyboard?.instantiateViewController(withIdentifier: "AddGroup") {
            present(addGroupVC, animated: true, completion: nil)
        }
    }
}

extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupListCell.self), for: indexPath)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let groupCell = cell as? GroupListCell else { return cell }

        return groupCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "SegueGroupDetail", sender: nil)
    }
}

extension GroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
