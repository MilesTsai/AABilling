//
//  AddBillViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddBillViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func expenseDetail(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Friend", bundle: nil)
        let expenseVC =
            storyboard.instantiateViewController(
                withIdentifier: String(describing: "ExpenseDetail"))
            present(expenseVC, animated: true, completion: nil)
        
    }

}
