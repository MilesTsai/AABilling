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
    
    let name: String?
    
    let email: String?
    
    let storage: String?
    
    let uid: String?
    
    let status: Int?
    
    var totalAccount: Int?
    
    var dictionary: [String: Any] {
        return [
            "name": name ?? "",
            "email": email ?? "",
            "storage": storage ?? "",
            "uid": uid ?? "",
            "status": status ?? "",
            "totalAccount": totalAccount ?? ""
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case email
        
        case storage
        
        case uid
        
        case status
        
        case totalAccount
    }
}

extension PersonalData: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name =
                    dictionary["name"] as? String,
              let email =
                    dictionary["email"] as? String,
              let storage =
                    dictionary["storage"] as? String,
              let uid =
                    dictionary["uid"] as? String,
              let status =
                    dictionary["status"] as? Int,
              let totalAccount =
                    dictionary["totalAccount"] as? Int
              else { return nil }
        
        self.init(
            name: name,
            email: email,
            storage: storage,
            uid: uid,
            status: status,
            totalAccount: totalAccount
        )
    }
}
