//
//  Extensions.swift
//  SwiftUIMessageTutorial
//
//  Created by Abhi B on 8/31/22.
//

import Foundation
import UIKit

extension UIViewController {

    /// Top most view controller in view hierarchy
    var topMostViewController: UIViewController {

        // No presented view controller? Current controller is the most view controller
        guard let presentedViewController = self.presentedViewController else {
            return self
        }

        // Presenting a navigation controller?
        // Top most view controller is in visible view controller hierarchy
        if let navigation = presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController
            } else {
                return navigation.topMostViewController
            }
        }

        // Presenting a tab bar controller?
        // Top most view controller is in visible view controller hierarchy
        if let tabBar = presentedViewController as? UITabBarController {
            if let selectedTab = tabBar.selectedViewController {
                return selectedTab.topMostViewController
            } else {
                return tabBar.topMostViewController
            }
        }

        // Presenting another kind of view controller?
        // Top most view controller is in visible view controller hierarchy
        return presentedViewController.topMostViewController
    }

}

extension UIWindow {

    /// Top most view controller in view hierarchy
    /// - Note: Wrapper to UIViewController.topMostViewController
    var topMostViewController: UIViewController? {
        return self.rootViewController?.topMostViewController
    }

}

extension UIApplication {

    /// Top most view controller in view hierarchy
    /// - Note: Wrapper to UIWindow.topMostViewController
    var topMostViewController: UIViewController? {
        return self.keyWindow?.topMostViewController
    }
}



