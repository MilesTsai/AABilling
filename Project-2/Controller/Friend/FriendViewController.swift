//
//  FriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class FriendViewController: BaseViewController {

    @IBOutlet weak var oweLabel: UILabel!
    
    @IBOutlet weak var lentLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.dataSource = self

            tableView.delegate = self

            tableView.separatorStyle = .none
        }
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue) {
        
    }
    
    var friendList = [PersonalData]() {

        didSet {
            print("")
        }
    }
    
    var acceptsList = [PersonalData]() {
        
        didSet {
            print("")
        }
    }
    
    var friends = [PersonalData]() {
        
        didSet {
            
            var sum = 0
            
            var owe = 0
            
            var lent = 0
            
            for friend in friends {

                guard let total = friend.totalAccount else { return }
                
                sum += total
                
                totalLabel.text = "$\(sum)"
                
                if total < 0 {
                    
                    var money = total
                    
                    money.negate()
                    
                    owe += money
                    
                    oweLabel.text = "$\(owe)"
                    
                } else if total > 0 {
                    
                    lent += total
                    
                    lentLabel.text = "$\(lent)"
                    
                } else if total == 0 {
                    
                    oweLabel.text = "$\(total)"
                    
                    lentLabel.text = "$\(total)"
                }
            }
            if owe == 0 {
                oweLabel.text = "$0"
            } else if lent == 0 {
                lentLabel.text = "$0"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteFriendList(data:)),
            name: NSNotification.Name("deleteFriend"),
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        PushNotificationManager.shared.registerForPushNotifications()
        
        PushNotificationManager.shared.updateFirestorePushTokenIfNeeded(uid: currentUser.uid)
        
        readFriendListData()
        
    }
    
    @objc func deleteFriendList(data: Notification) {
        let friendUid = data.userInfo?["friendUid"] as? String
        for (index, element) in friends.enumerated() {
            if element.uid == friendUid {
                friends.remove(at: index)
            }
            tableView.reloadData()
        }
    }
    
    private func setupTableView() {

        tableView.mls_registerCellWithNib(
            identifier: String(describing: FriendListCell.self),
            bundle: nil
        )
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: FriendSectionCell.self),
            bundle: nil
        )
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: NoInviteCell.self),
            bundle: nil
        )
        
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.readFriendListData()
        })
    }
    
    func readFriendListData() {
        
        FirebaseManager.shared.readFriendListData { [weak self] (friendList) in
            self?.friendList = friendList
            
            self?.acceptList()
            
            FirebaseManager.shared.updateToken(friends: self?.friends ?? [])
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                
                self?.tableView.mj_header.endRefreshing()
                
            }
        }
    }

    lazy var addFriendVC =
        storyboard!.instantiateViewController(withIdentifier: "AddFriend")
    
    @IBAction func addFriend(_ sender: UIBarButtonItem) {

//        view.stickSubView(addFriendVC.view)
        
//        view.addSubview(addFriendVC.view)
        
//            addFriendVC.willMove(toParent: self)
//
//            addChild(addFriendVC)
            addFriendVC.modalPresentationStyle = .overCurrentContext
            present(addFriendVC, animated: false, completion: nil)
//        Crashlytics.sharedInstance().crash()
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
    }
    
    func acceptList() {
        
        var tempFriend: [PersonalData] = []
        
        var tempInvitation: [PersonalData] = []
        
        for accepts in 0..<friendList.count {
            
            if friendList[accepts].status == 0 {
            
                tempInvitation.append(friendList[accepts])
                
            } else if friendList[accepts].status == 1 {
                
                tempFriend.append(friendList[accepts])
                
            }
            
            acceptsList = tempInvitation
            
            friends = tempFriend
        }
    }
}

extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: String(describing: FriendSectionCell.self))
        
        guard let friendSectionCell =
            cell as? FriendSectionCell else { return cell }
        
        if section == 0 {
            
            friendSectionCell.sectionTitle.text = "好友邀請"
            
        } else {
            
            friendSectionCell.sectionTitle.text = "好友"
        }
        
        return friendSectionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if acceptsList.count == 0 {
                return 1
            } else {
                return acceptsList.count
            }
        } else {
            return friends.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if acceptsList.count == 0 {
                
                let inviteCell =
                    tableView.dequeueReusableCell(withIdentifier: String(describing: NoInviteCell.self), for: indexPath)
                
                guard let noInviteCell = inviteCell as? NoInviteCell else { return inviteCell }
                
                return noInviteCell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)
                
                guard let friendCell =
                    cell as? FriendListCell else { return cell }
                
                friendCell.accessoryType = UITableViewCell.AccessoryType.none
                
                let list = acceptsList[indexPath.row]
                
                friendCell.userName.text = list.name
                
                friendCell.acceptBtn.isHidden = false
                
                friendCell.refuseBtn.isHidden = false
                
                friendCell.acceptBtn.addTarget(
                    self,
                    action: #selector(self.accept(_:)),
                    for: .touchUpInside
                )
                
                friendCell.refuseBtn.addTarget(
                    self,
                    action: #selector(self.refuse(_:)),
                    for: .touchUpInside
                )
                
                friendCell.acceptBtn.tag = indexPath.row
                
                friendCell.refuseBtn.tag = indexPath.row
                
                return friendCell
                
            }
            
        } else if indexPath.section == 1 {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)
            
            guard let friendCell =
                cell as? FriendListCell else { return cell }
         
            friendCell.acceptBtn.isHidden = true
            
            friendCell.refuseBtn.isHidden = true
            
            let list = friends[indexPath.row]
            
            guard var total = list.totalAccount else { return friendCell }
            
            friendCell.userName.text = list.name
            
            friendCell.accountsStatus.text = ""
            
            friendCell.accountsSum.text = "$\(String(describing: total))"
            
            if total > 0 {
                
                friendCell.accountsStatus.text = "借出"
                
                friendCell.accountsStatus.textColor = .init(cgColor: #colorLiteral(red: 0.2470588235, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
                
                friendCell.accountsSum.text = "$\(String(describing: total))"
                
            } else if total < 0 {
                
                friendCell.accountsStatus.text = "欠款"
                
                friendCell.accountsStatus.textColor = .red
                
                total.negate()
                
                friendCell.accountsSum.text = "$\(String(describing: total))"
                
            } else if total == 0 {
                
                friendCell.accountsStatus.text = "銀貨兩訖"
                
                friendCell.accountsStatus.textColor = .init(cgColor: #colorLiteral(red: 0.2470588235, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
                
                friendCell.accountsSum.text = "$\(String(describing: total))"
            }
            return friendCell
        }
        
        return UITableViewCell()
    }
    
    @objc func accept(_ sender: UIButton) {
        
        guard let acceptUid = acceptsList[sender.tag].uid else { return }
        
        FirebaseManager.shared.updateMyStatus(document: acceptUid)
        FirebaseManager.shared.updateFriendStatus(document: acceptUid)
    }
    
    @objc func refuse(_ sender: UIButton) {
        
        guard let acceptUid = acceptsList[sender.tag].uid else { return }
        
        FirebaseManager.shared.deleteFriend(document: acceptUid)
        
        acceptsList.remove(at: sender.tag)
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
          performSegue(withIdentifier: "SegueFriendDetail", sender: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 {
        
            return nil
        }
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFriendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let friendDetailVC =
                          segue.destination as? FriendDetailViewController else { return }
                friendDetailVC.friendData = friends[indexPath.row]
            }
        }
    }
}

extension FriendViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}
