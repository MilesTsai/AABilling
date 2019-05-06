//
//  BillingDetailObject.swift
//  Project-2
//
//  Created by User on 2019/4/22.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

protocol UserDocument {
    init?(dictionary: [String: Any])
}

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

extension UserData: UserDocument {
    init?(dictionary: [String: Any]) {
        guard let name =
            dictionary["name"] as? String,
            let email =
            dictionary["email"] as? String,
            let storage =
            dictionary["storage"] as? String,
            let uid =
            dictionary["uid"] as? String,
            let fcmToken =
            dictionary["fcmToken"] as? String
            else { return nil }
        
        self.init(
            name: name,
            email: email,
            storage: storage,
            uid: uid,
            fcmToken: fcmToken
        )
    }
}
