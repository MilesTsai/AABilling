//
//  FriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

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
    
    var dataBase: Firestore = Firestore.firestore()
    
    let currentUser = Auth.auth().currentUser
    
    var friendList = [PersonalData]()
    
    var sum = 0
    
    var owe = 0
    
    var lent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        loadData()
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
    
    func loadData() {
        
        dataBase
            .collection("users")
            .document(currentUser?.uid ?? "")
            .collection("friends")
            .addSnapshotListener { querySnapshot, error in
            
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    guard let snapshot =
                              querySnapshot else { return }
                    
                    self.friendList =
                         snapshot
                            .documents
                            .compactMap({
                                PersonalData(dictionary: $0.data())
                            })
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                }
            }
    }

    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        if let addFriendVC =
               storyboard?.instantiateViewController(withIdentifier: "AddFriend") {
            addFriendVC.modalPresentationStyle = .overCurrentContext
            present(addFriendVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
    }
    
}

extension FriendViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendList.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =
            tableView.dequeueReusableCell(withIdentifier: String(describing: FriendListCell.self), for: indexPath)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        guard let friendCell =
                  cell as? FriendListCell else { return cell }
        
        let list = friendList[indexPath.row]
        
        guard var total = list.totalAccount else { return friendCell }
        
        for totals in total...total {
            sum += totals
        }
        
        totalLabel.text = "$\(sum)"
        
        friendCell.userName.text = list.name
        
        friendCell.accountsSum.text = "$\(String(describing: total))"
        
        if total > 0 {
            
            friendCell.accountsStatus.text = "未取款"
            
            friendCell.accountsSum.text = "$\(String(describing: total))"
            
            for totals in total...total {
                lent += totals
            }
            
            lentLabel.text = "$\(lent)"
            
        } else if total < 0 {
            
            friendCell.accountsStatus.text = "欠款"
            
            total.negate()
            
            friendCell.accountsSum.text = "$\(String(describing: total))"
            
            for totals in total...total {
                owe += totals
            }
            
            oweLabel.text = "$\(owe)"
        }

        return friendCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "SegueFriendDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueFriendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let friendDetailVC =
                          segue.destination as? FriendDetailViewController else { return }
                friendDetailVC.friendData = friendList[indexPath.row]
//                print("=========")
//                print(friendDetailVC.friendData)
            }
        }
    }
}

extension FriendViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
