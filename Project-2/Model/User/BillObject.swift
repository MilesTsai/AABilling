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
    
    let billUid: String?
    
    let name: String?
    
    let billName: String?
    
    let amountTotal: Int?
    
    let owedAmount: Int?
    
    let payAmount: Int?
    
    let status: Int?
    
    var dictionary: [String: Any] {
        return [
            "name": name ?? "",
            "billName": billName ?? "",
            "amountTotal": amountTotal ?? "",
            "uid": uid ?? "",
            "status": status ?? "",
            "owedAmount": owedAmount ?? "",
            "payAmount": payAmount ?? "",
            "billUid": billUid ?? ""
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case uid
        
        case name
        
        case billName
        
        case amountTotal
        
        case owedAmount
        
        case payAmount
        
        case status
        
        case billUid
    }
}

struct BillingContent {
    
    let anyone: String
    
    let billName: String
    
    let amount: Int
}

extension BillData {
    init?(dictionary: [String: Any]) {
        guard let name =
            dictionary["name"] as? String,
            let billName =
            dictionary["billName"] as? String,
            let amountTotal =
            dictionary["amountTotal"] as? Int,
            let uid =
            dictionary["uid"] as? String,
            let billUid =
            dictionary["billUid"] as? String,
            let status =
            dictionary["status"] as? Int,
            let owedAmount =
            dictionary["owedAmount"] as? Int,
            let payAmount =
            dictionary["payAmount"] as? Int
            else {
                return nil

        }

        self.init(
            uid: uid,
            billUid: billUid,
            name: name,
            billName: billName,
            amountTotal: amountTotal,
            owedAmount: owedAmount,
            payAmount: payAmount,
            status: status
        )
    }
}
