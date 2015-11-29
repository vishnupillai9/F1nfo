//
//  QuickActions.swift
//  F1nfo
//
//  Created by Vishnu on 21/11/15.
//  Copyright © 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class QuickActions {
    
    enum ShortcutIdentifier: String {
        case OpenFavorites
        case OpenStandings
        case OpenSchedule
        
        init?(fullIdentifier: String) {
            guard let shortIdentifier = fullIdentifier.componentsSeparatedByString(".").last else {
                return nil
            }
            self.init(rawValue: shortIdentifier)
        }
    }
    
    class func selectTabBarItemForIdentifier(identifier: ShortcutIdentifier) -> Bool {
        guard let tabBarController = (UIApplication.sharedApplication().delegate)!.window??.rootViewController as? UITabBarController else {
            return false
        }
        
        switch identifier {
            case .OpenFavorites:
                tabBarController.selectedIndex = 0
                return true
            case .OpenStandings:
                tabBarController.selectedIndex = 1
                return true
            case .OpenSchedule:
                tabBarController.selectedIndex = 2
                return true
        }
    }
    
    @available(iOS 9.0, *)
    class func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullIdentifier: shortcutType) else {
            return false
        }
        return selectTabBarItemForIdentifier(shortcutIdentifier)
    }
    
}