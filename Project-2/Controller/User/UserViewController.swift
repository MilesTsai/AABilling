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
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userEmail: UILabel!
    
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
        
        dataBase.collection("users").document(currentUser?.uid ?? "").getDocument(completion: { [weak self] (snapshot, _) in
            let user = snapshot?.data()
            self?.userData = UserData(
                name: user?[PersonalData.CodingKeys.name.rawValue] as? String,
                email: user?[PersonalData.CodingKeys.email.rawValue] as? String,
                storage: user?[PersonalData.CodingKeys.storage.rawValue] as? String,
                uid: user?[PersonalData.CodingKeys.uid.rawValue] as? String)
            
            self?.userName.text = self?.userData?.name
            
            self?.userEmail.text = self?.userData?.email
        })
        
        loadData()
    }
    
    private func setupTableView() {
        
        lentListTableView.mls_registerCellWithNib(
            identifier: String(describing: LentCell.self),
            bundle: nil
        )
    }
    
    func loadData() {
        
        dataBase
            .collection("users")
            .document(currentUser?.uid ?? "")
            .collection("friends")
            .order(by: "name", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    guard let snapshot =
                        querySnapshot else { return }
                    
                    self?.friendList =
                        snapshot
                            .documents
                            .compactMap({
                                PersonalData(dictionary: $0.data())
                            })
                    
                    self?.list()
                    
                    DispatchQueue.main.async {
                        
                        self?.lentListTableView.reloadData()
                    }
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
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: String(describing: LentCell.self), for: indexPath)
        
        guard let friendCell =
            cell as? LentCell else { return cell }
        
        let list = lentList[indexPath.row]
        
        guard let total = list.totalAccount else { return friendCell }
        
        friendCell.userName.text = list.name
        
        friendCell.statusAccount.text = "未取款"
        
        friendCell.sumAccount.text = "$\(String(describing: total))"
        
        return friendCell
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
