//
//  FriendSectionCell.swift
//  Project-2
//
//  Created by User on 2019/4/23.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FriendSectionCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    
    @IBOutlet weak var sectionBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sectionBackgroundView
            .setGradientBackground(
                colorTop: #colorLiteral(red: 0.9143932462, green: 0.5653278232, blue: 0.23640728, alpha: 1),
                colorBottom: #colorLiteral(red: 0.9143932462, green: 0.5653278232, blue: 0.23640728, alpha: 1),
                startPoint: CGPoint(x: 0.0, y: 0.2),
                endPoint: CGPoint(x: 0.0, y: 0.0)
        )
        
//        self.accessoryType = UITableViewCell.AccessoryType.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
