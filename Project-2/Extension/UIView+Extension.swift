//
//  UIView+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

@IBDesignable

extension UIView {

    @IBInspectable var mlsBorderColor: UIColor? {
        get {
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var mlsBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var mlsCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func stickSubView(_ objectView: UIView) {
        
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func stickSubView(_ objectView: UIView, inset: UIEdgeInsets) {
        
        objectView.removeFromSuperview()
        
        addSubview(objectView)
        
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        
        objectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
        
        objectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset.right).isActive = true
        
        objectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
    }
}
