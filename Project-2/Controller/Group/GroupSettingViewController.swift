//
//  GroupSettingViewController.swift
//  Project-2
//
//  Created by User on 2019/4/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func cancelGroupSetting(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
