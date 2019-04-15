//
//  UserObject.swift
//  Project-2
//
//  Created by User on 2019/4/15.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct PersonalData {
    
    let displayName: String?
    
    let email: String?
    
    let storage: String?
    
    var dictionary: [String: Any] {
        return [
            "displayName": displayName ?? "",
            "email": email ?? "",
            "storage": storage ?? ""
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case displayName
        
        case email
        
        case storage
    }
}

extension PersonalData: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let displayName = dictionary["displayName"] as? String,
        let email = dictionary["email"] as? String,
        
            let storage = dictionary["storage"] as? String else { return nil }
        
        self.init(displayName: displayName, email: email, storage: storage)
    }
}
