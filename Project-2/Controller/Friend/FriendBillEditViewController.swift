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

    @IBAction func expenseDetail(_ sender: UIButton) {
        if let expenseDetailVC =
            storyboard?.instantiateViewController(withIdentifier: "FriendExpense") {

            present(expenseDetailVC, animated: true, completion: nil)
        }
    }

}
