//
//  UITableView+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/4.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

extension UITableView {

    func mls_registerCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellReuseIdentifier: identifier)
    }

    func mls_registerHeaderWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
