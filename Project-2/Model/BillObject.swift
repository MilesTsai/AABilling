//
//  BillObject.swift
//  Project-2
//
//  Created by User on 2019/4/16.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

struct BillData {
    
    let uid: String?
    
    let name: String?
    
    let billName: String?
    
    let amountTotal: Int?
    
    let owedAmount: Int?
    
    let payAmount: Int?
    
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case uid
        
        case name
        
        case billName
        
        case amountTotal
        
        case owedAmount
        
        case payAmount
        
        case status
    }
}
