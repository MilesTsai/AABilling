//
//  LentCell.swift
//  Project-2
//
//  Created by User on 2019/5/4.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class LentCell: UITableViewCell {
    
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var statusAccount: UILabel!
    
    
    @IBOutlet weak var sumAccount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
