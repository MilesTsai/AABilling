//
//  UINavigationBar+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/26.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        var updatedFrame = self.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(cgColor: #colorLiteral(red: 0.2717267275, green: 0.3133575916, blue: 0.3388757706, alpha: 1)).cgColor, UIColor.init(cgColor: #colorLiteral(red: 0.9763852954, green: 0.9765252471, blue: 0.9763546586, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 4.0) // vertical gradient end
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image, for: UIBarMetrics.default)
    }
}
