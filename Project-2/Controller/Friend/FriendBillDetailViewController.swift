//
//  FriendBillDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendBillDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    @IBAction func backFreindDetail(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func friendBillEdit(_ sender: UIBarButtonItem) {
        if let billEditVC = storyboard?.instantiateViewController(withIdentifier: "FriendBillEdit") {

            present(billEditVC, animated: true, completion: nil)
        }
    }

}
