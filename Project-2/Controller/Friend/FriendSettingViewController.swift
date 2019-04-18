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

    override func viewDidLoad() {
        super.viewDidLoad()

//        friendEmail.text = friendDetailData?.email
        // Do any additional setup after loading the view.
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
    }

}
