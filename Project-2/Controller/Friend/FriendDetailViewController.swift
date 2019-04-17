//
//  FriendDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class FriendDetailViewController: BaseViewController {

    @IBOutlet weak var friendDetailTableView: UITableView! {

        didSet {

            friendDetailTableView.dataSource = self

            friendDetailTableView.delegate = self
        }
    }
    
    var dataBase: Firestore = Firestore.firestore()

    var friendData: PersonalData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

    }

    private func setupTableView() {

        friendDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: FriendDetailCell.self),
            bundle: nil
        )

        friendDetailTableView.mls_registerCellWithNib(
            identifier: String(describing: FriendAccountsListDetailCell.self),
            bundle: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func backFriendList(_ sender: UIButton) {

        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func friendSetting(_ sender: UIButton) {
        
        guard let nextVC =
                    storyboard?.instantiateViewController(
                        withIdentifier: "FriendSetting")
                        as? UINavigationController else { return }
        
        guard let friendSettingVC =
                    nextVC.topViewController as? FriendSettingViewController else { return }
  
        friendSettingVC.friendDetailData = friendData
        present(nextVC, animated: true, completion: nil)
//        performSegue(withIdentifier: "SegueFriendSetting", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SegueFriendSetting" {
//            guard let friendSettingVC =
//                segue.destination
//                    as? UINavigationController else {
//                        return
//            }
//            guard let nextVC = friendSettingVC.children[0] as? FriendSettingViewController else {return}
//            nextVC.friendDetailData = friendData
//        }
//    }
}

extension FriendDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendDetailCell.self)
                )
        
        guard let friendHeaderCell =
                    headerCell as? FriendDetailCell else { return headerCell }
        
        friendHeaderCell.settleUpBtn.addTarget(
            self, action: #selector(self.friendSettleUp),
            for: .touchUpInside
        )
        
        friendHeaderCell.friendName.text = friendData?.name
        
        return friendHeaderCell
    }
    
    @objc func friendSettleUp() {
        
        let storyboard = UIStoryboard(name: "Friend", bundle: nil)
        let settleVC =
                storyboard.instantiateViewController(
                    withIdentifier: String(
                    describing: FriendSettleUpViewController.self)
                )
            present(settleVC, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: String(describing: FriendAccountsListDetailCell.self),
                for: indexPath
                )

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let accountsDetailCell =
                    cell as? FriendAccountsListDetailCell else { return cell }
        
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
        return 60
    }
}
