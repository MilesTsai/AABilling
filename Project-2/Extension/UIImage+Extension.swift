//
//  UIImage+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

enum ImageSource: String {

    case friend
    case friendselect
    case group
    case groupselect
    case addBill
    case addBillselect
    case chart
    case chartselect
    case user
    case userselect
}

extension UIImage {

    static func source(_ source: ImageSource) -> UIImage? {

        return UIImage(named: source.rawValue)

    }
}
