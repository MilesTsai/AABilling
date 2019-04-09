//
//  FriendBillEditViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendBillEditViewController: BaseViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    @IBAction func cancelEditBill(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ExpenseDetail(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendExpense") {
            
            present(vc, animated: true, completion: nil)
        }
    }
    
}
