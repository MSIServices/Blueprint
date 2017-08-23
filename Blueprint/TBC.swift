//
//  TBC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let TAB_BAR_COLOR: UIColor = CHAIN_BLUE
fileprivate let TEXT_COLOR_NORMAL: UIColor = UIColor.white
fileprivate let TEXT_COLOR_SELECTED: UIColor = CHAIN_CREAM
fileprivate let TITLES = ["Home", "New Post"]
fileprivate let FONT: String = "OpenSans-Regular"
fileprivate let NORMAL_IMAGES = ["home-white", "new-post-white"]
fileprivate let SELECTED_IMAGES = ["home-cream", "new-post-cream"]

class TBC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = TAB_BAR_COLOR
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: TEXT_COLOR_SELECTED], for: UIControlState.selected)
        
        for (idx,item) in tabBar.items!.enumerated() {
            
            item.image = UIImage(named: NORMAL_IMAGES[idx])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage = UIImage(named: SELECTED_IMAGES[idx])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.setTitleTextAttributes([NSFontAttributeName: UIFont(name: FONT, size: 9.0)!, NSForegroundColorAttributeName: TEXT_COLOR_NORMAL], for: .normal)
            item.title = TITLES[idx]
        }
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.switchTabs(notification:)), name: Notification.Name(rawValue: "SwitchTab"), object: nil)
    }
    
    func switchTabs(notification: NSNotification) {
        selectedIndex = notification.userInfo?["index"] as! Int
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let indexOfTab = viewControllers?.index(of: viewController)!
        UserDefaults.standard.set(indexOfTab, forKey: CURRENT_TAB)
    }

}
