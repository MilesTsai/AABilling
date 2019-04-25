//
//  FriendSettleUpViewController.swift
//  Project-2
//
//  Created by User on 2019/4/10.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendSettleUpViewController: BaseViewController {

    @IBOutlet weak var settleUpLabel: UILabel!
    
    @IBOutlet weak var settleUpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func settleUpCancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
