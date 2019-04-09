//
//  FreindExpenseDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FreindExpenseDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelExpenseDetail(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
