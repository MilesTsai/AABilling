//
//  AddGroupViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddGroupViewController: BaseViewController {

    @IBOutlet weak var addGroupName: TextFieldPlaceholder!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

        self.addGroupName.becomeFirstResponder()
    }

    @IBAction func cancelAddGroup(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
