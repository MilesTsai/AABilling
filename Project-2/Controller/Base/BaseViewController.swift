//
//  BaseViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var isHideNavigationBar: Bool {
        
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHideNavigationBar {
            
            navigationItem.hidesBackButton = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

}
