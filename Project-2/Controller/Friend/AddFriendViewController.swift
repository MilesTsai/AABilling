//
//  AddFriendViewController.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AddFriendViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var addEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.contentView.isHidden = false

            self?.addEmail.becomeFirstResponder()
        })
    }

    @IBAction func cancelAddFriend(_ sender: UIButton) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
