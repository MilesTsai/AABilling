//
//  FriendTableViewCell.swift
//  Project-2
//
//  Created by User on 2019/4/4.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var accountsStatus: UILabel!

    @IBOutlet weak var accountsSum: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var refuseBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        acceptBtn.isHidden = true
        
        refuseBtn.isHidden = true
        
        accountsStatus.text = ""
        
        accountsSum.text = ""
        
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
