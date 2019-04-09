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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setupTableView() {

        tableView.mls_registerCellWithNib(
            identifier: String(describing: FriendListCell.self),
            bundle: nil
        )
    }

    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        if let addFriendVC =
            storyboard?.instantiateViewController(withIdentifier: "AddFriend") {
            addFriendVC.modalPresentationStyle = .overCurrentContext
            present(addFriendVC, animated: true, completion: nil)
        }
    }
}

extension FriendViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =
            tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let friendCell = cell as? FriendListCell else { return cell }

        return friendCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "SegueFriendDetail", sender: nil)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SegueFriendDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                guard let vc = segue.destination as? FriendDetailViewController else { return }
//
//            }
//
//        }

    }

extension FriendViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
