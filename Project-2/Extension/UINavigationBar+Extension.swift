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
        gradientLayer.colors = [UIColor.init(cgColor: #colorLiteral(red: 0.3787093759, green: 0.721126616, blue: 0.5331062078, alpha: 1)).cgColor,
                                UIColor.init(cgColor: #colorLiteral(red: 0.3796112835, green: 0.7213348746, blue: 0.5370011926, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.5) // vertical gradient end
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image, for: UIBarMetrics.default)
    }
}
