//
//  UserViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: BaseViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var userName: TextFieldPlaceholder!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var pushNotification: UIButton!
    
    @IBOutlet weak var lentListTableView: UITableView! {
        
        didSet {
            
            lentListTableView.dataSource = self
            
            lentListTableView.delegate = self
            
            lentListTableView.separatorStyle = .none
        }
    }
    
    var userData: UserData?
    
    var dataBase: Firestore = Firestore.firestore()
    
    let currentUser = Auth.auth().currentUser
    
    var friendList = [PersonalData]()
    
    var lentList = [PersonalData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseManager.shared.readUserData { [weak self] (userData) in
            
            self?.userData = userData
            
            self?.userName.text = self?.userData?.name
            
            self?.userEmail.text = self?.userData?.email
            
            if self?.lentList.count == 0 {
                self?.pushNotification.isHidden = true
            } else {
                self?.pushNotification.isHidden = false
            }
        }
        
        loadData()
        
    }
    
    private func setupTableView() {
        
        lentListTableView.mls_registerCellWithNib(
            identifier: String(describing: LentCell.self),
            bundle: nil
        )
        
        lentListTableView.mls_registerCellWithNib(
            identifier: String(describing: NoLentCell.self),
            bundle: nil
        )
    }
    
    func loadData() {
        
        FirebaseManager.shared.readFriendListData { [weak self] (friendList) in
            
            self?.friendList = friendList
            
            self?.list()
            
            DispatchQueue.main.async {
                
                self?.lentListTableView.reloadData()
            }
        }
    }
    
    func list() {
        
        var tempLentList: [PersonalData] = []
        
        for lists in 0..<friendList.count {
            
            guard let totalAccountList = friendList[lists].totalAccount else { return }
            
            if totalAccountList > 0 {
                
                tempLentList.append(friendList[lists])
                
            }
            
            lentList = tempLentList
        }
    }
    
    @IBAction func saveUserData(_ sender: UIBarButtonItem) {
        
        if userName.text == "" {
            AlertManager().alertView(title: "錯誤", message: "請輸入名稱", view: self)
        } else {
            FirebaseManager.shared.updateUserName(name: userName.text ?? "")
            AlertManager().alertView(title: "成功", message: "名稱已更換", view: self)
        }
        
        for list in friendList {
            guard let friendUid = list.uid else { return }
            
            FirebaseManager.shared.updateUserName(friendID: friendUid, name: userName.text ?? "")
        }
    }
    
    @IBAction func pushNotificationForList(_ sender: UIButton) {
        
        guard let userName = userData?.name else { return }
        
        let alertController =
            UIAlertController(
                title: "提醒",
                message: "您確定一鍵發送款項未結清訊息？",
                preferredStyle: .alert
        )
        
        let cancelAction =
            UIAlertAction(
                title: "取消",
                style: .default,
                handler: { _ in
                    
            })
        
        let okAction =
            UIAlertAction(
                title: "確定",
                style: .default,
                handler: { [weak self] _ in
                    
                    for document in self!.lentList {
                        
                        guard let token = document.fcmToken else { return }
                        
                        let sender = PushNotificationSender()
                        sender.sendPushNotification(
                            to: token,
                            title: "溫馨提醒",
                            body: "目前您與\(userName)尚有款項未結清"
                        )
                    }
            })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if lentList.count == 0 {
            return 1
        } else {
            return lentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if lentList.count == 0 {
            
            let secondCell =
                tableView.dequeueReusableCell(withIdentifier: String(describing: NoLentCell.self), for: indexPath)
            
            guard let noFriendCell =
                secondCell as? NoLentCell else { return secondCell }

//            noFriendCell.noLentLogo.text = "暫無未還款的朋友"

            return noFriendCell

        } else {
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: String(describing: LentCell.self), for: indexPath)
            
            guard let friendCell =
                cell as? LentCell else { return cell }
            
            let list = lentList[indexPath.row]
            
            guard let total = list.totalAccount else { return friendCell }
            
            friendCell.userName.text = list.name
            
            friendCell.statusAccount.text = "借出"
            
            friendCell.sumAccount.text = "$\(String(describing: total))"
            
            return friendCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lentList.count != 0 {
            
            guard let token = lentList[indexPath.row].fcmToken else { return }
            
            guard let userName = userData?.name else { return }
            
            guard let friendName = lentList[indexPath.row].name else { return }
            
            let alertController =
                UIAlertController(
                    title: "提醒",
                    message: "您確定對\(friendName)發送款項未結清訊息？",
                    preferredStyle: .alert
            )
            
            let cancelAction =
                UIAlertAction(
                    title: "取消",
                    style: .default,
                    handler: { _ in
                        
                })
            
            let okAction =
                UIAlertAction(
                    title: "確定",
                    style: .default,
                    handler: { _ in
                        
                        let sender = PushNotificationSender()
                        sender.sendPushNotification(
                            to: token,
                            title: "溫馨提醒",
                            body: "目前您與\(userName)尚有款項未結清"
                        )
                })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if lentList.count == 0 {
            
            return nil
        }
        
        return indexPath
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
