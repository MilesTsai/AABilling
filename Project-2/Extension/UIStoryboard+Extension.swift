//
//  UIStoryboard+Extension.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let friend = "Friend"

    static let group = "Group"

    static let addBill = "AddBill"

    static let chart = "Chart"

    static let user = "User"
}

extension UIStoryboard {

    static var main: UIStoryboard { return storyboard(name: StoryboardCategory.main) }

    static var friend: UIStoryboard { return storyboard(name: StoryboardCategory.friend) }

    static var group: UIStoryboard { return storyboard(name: StoryboardCategory.group) }

    static var addBill: UIStoryboard { return storyboard(name: StoryboardCategory.addBill) }

    static var chart: UIStoryboard { return storyboard(name: StoryboardCategory.chart) }

    static var user: UIStoryboard { return storyboard(name: StoryboardCategory.user) }

    private static func storyboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
