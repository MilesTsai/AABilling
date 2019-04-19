//
//  BillObject.swift
//  Project-2
//
//  Created by User on 2019/4/16.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

struct BillData {
    
    let name: String?
    
    let billName: String?
    
    let amountTotal: Int?
    
    let owedAmount: Int?
    
    let payAmount: Int?
    
    let status: Int?
    
    let uid: String?
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case billName
        
        case amountTotal
        
        case owedAmount
        
        case payAmount
        
        case status
        
        case uid
    }
}
