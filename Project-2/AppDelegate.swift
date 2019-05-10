//
//  AppDelegate.swift
//  Project-2
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        FirebaseManager.shared.configure()
//        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])

        return true
    }
}
