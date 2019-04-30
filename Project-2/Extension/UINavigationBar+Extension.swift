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
        gradientLayer.colors = [UIColor.init(cgColor: #colorLiteral(red: 0.1962916255, green: 0.1593724787, blue: 0.120939143, alpha: 1)).cgColor, UIColor.init(cgColor: #colorLiteral(red: 0.9734193683, green: 0.9823022485, blue: 0.9787819982, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.5) // vertical gradient end
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image, for: UIBarMetrics.default)
    }
}
