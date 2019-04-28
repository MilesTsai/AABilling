//
//  FriendSettingViewController.swift
//  Project-2
//
//  Created by User on 2019/4/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendSettingViewController: BaseViewController {

    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendEmail: UILabel!
    
    var friendDetailData: PersonalData?
    
    var friendUid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        friendName.text = friendDetailData?.name
        
        friendEmail.text = friendDetailData?.email
    }

    @IBAction func cancelFriendSetting(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteFriend(_ sender: UIButton) {
        
        let alertController =
            UIAlertController(
                title: "注意",
                message: "您確定刪除此好友？",
                preferredStyle: .alert
        )
        
        let okAction =
            UIAlertAction(
                title: "確定",
                style: .default,
                handler: { _ in
                    print("Hello")
            })
        
        let cancelAction =
            UIAlertAction(
                title: "取消",
                style: .default,
                handler: { _ in
                    print("GO")
            })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
//        guard let friendUid = friendDetailData?.uid else {
//            return
//        }
//
//        NotificationCenter.default.post(name: NSNotification.Name("deleteFriend"), object: nil, userInfo: ["friendUid": friendUid])
//
//        FirebaseManager.shared.deleteFriend(document: friendUid)
        
    }
}
