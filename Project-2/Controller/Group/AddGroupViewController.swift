//
//  AddGroupViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {

    @IBOutlet weak var addGroupName: TextFieldPlaceholder!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6709331784, green: 0.7987587246, blue: 0.7739934854, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.isTranslucent = false

        self.addGroupName.becomeFirstResponder()
    }

    @IBAction func cancelAddGroup(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
