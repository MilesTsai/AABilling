//
//  BillObject.swift
//  Project-2
//
//  Created by User on 2019/4/16.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

struct BillData {
    
    let displayName: String?
    
    let billName: String?
    
    let amount: Int?
    
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case displayName
        
        case billName
        
        case amount
        
        case status
    }
}
