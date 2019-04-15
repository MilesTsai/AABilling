//
//  FriendDetailTableViewCell.swift
//  Project-2
//
//  Created by User on 2019/4/7.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendDetailCell: UITableViewCell {

    @IBOutlet weak var friendPhoto: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendBill: UILabel!
    
    @IBOutlet weak var settleUpBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
