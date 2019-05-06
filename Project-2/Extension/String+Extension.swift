//
//  String+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/29.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

extension String {
    
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailText = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailText.evaluate(with: self)
    }
    
    var isPasswordValid: Bool {
        
        let passwordRegEx = "[a-zA-Z0-9]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: self)
    }
}
