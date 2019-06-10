//
//  BillingDetailObject.swift
//  Project-2
//
//  Created by User on 2019/4/22.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

struct UserData {
    
    let name: String?
    
    let email: String?
    
    let storage: String?
    
    let uid: String?
    
    let fcmToken: String?
    
    var dictionary: [String: Any] {
        return [
            "name": name ?? "",
            "email": email ?? "",
            "storage": storage ?? "",
            "uid": uid ?? "",
            "fcmToken": fcmToken ?? ""
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case email
        
        case storage
        
        case uid
        
        case fcmToken
    }
}

