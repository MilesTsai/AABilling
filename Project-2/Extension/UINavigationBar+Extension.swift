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
        updatedFrame.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(cgColor: #colorLiteral(red: 0.6168641719, green: 0.8565626917, blue: 0.9764705896, alpha: 1)).cgColor,
                                UIColor.init(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.5) // vertical gradient end
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image, for: UIBarMetrics.default)
    }
}
