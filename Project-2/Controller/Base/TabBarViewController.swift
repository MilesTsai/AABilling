//
//  TabBarViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

private enum Tab {

    case friend

//    case group

    case addBill

//    case chart
//
    case user

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .friend: controller = UIStoryboard.friend.instantiateInitialViewController()!

//        case .group: controller = UIStoryboard.group.instantiateInitialViewController()!

        case .addBill: controller = UIStoryboard.addBill.instantiateInitialViewController()!

//        case .chart: controller = UIStoryboard.chart.instantiateInitialViewController()!
//
        case .user: controller = UIStoryboard.user.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .friend:
            return UITabBarItem(
                title: nil,
                image: UIImage.source(.friend),
                selectedImage: UIImage.source(.friendselect)
            )

//        case .group:
//            return UITabBarItem(
//                title: nil,
//                image: UIImage.source(.group),
//                selectedImage: UIImage.source(.groupselect)
//            )

        case .addBill:
            return UITabBarItem(
                title: nil,
                image: UIImage.source(.addBill),
                selectedImage: UIImage.source(.addBillselect)
            )

//        case .chart:
//            return UITabBarItem(
//                title: nil,
//                image: UIImage.source(.chart),
//                selectedImage: UIImage.source(.chartselect)
//            )

        case .user:
            return UITabBarItem(
                title: nil,
                image: UIImage.source(.user),
                selectedImage: UIImage.source(.userselect)
            )
        }
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

//    private let tabs: [Tab] = [.friend, .group, .addBill, .chart, .user]
    private let tabs: [Tab] = [.friend, .addBill, .user]
    
    let layerGradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerGradient.colors = [
            UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor,
            UIColor.init(displayP3Red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1).cgColor]
        layerGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        layerGradient.endPoint = CGPoint(x: 0.0, y: 1.6)
        layerGradient.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height)
        self.tabBar.layer.addSublayer(layerGradient)

//        UITabBar.appearance().layer.borderWidth = 0.0
//        UITabBar.appearance().clipsToBounds = true
        
        viewControllers = tabs.map({ $0.controller() })

        delegate = self
        
        tabBar.isTranslucent = false
        
        view.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
    }
}
