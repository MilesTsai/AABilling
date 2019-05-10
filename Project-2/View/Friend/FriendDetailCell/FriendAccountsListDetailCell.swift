//
//  AccountsListDetailCell.swift
//  Project-2
//
//  Created by User on 2019/4/8.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendAccountsListDetailCell: UITableViewCell {
    
    @IBOutlet weak var billName: UILabel!
    
    @IBOutlet weak var sumOfMoneyStatus: UILabel!
    
    @IBOutlet weak var sumOfMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
