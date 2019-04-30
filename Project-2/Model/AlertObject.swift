//
//  AlertObject.swift
//  Project-2
//
//  Created by User on 2019/4/30.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class AlertManager {
    
    func alertView(title: String, message: String, view: UIViewController) {
        
        let alertController =
            UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction =
            UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
}
