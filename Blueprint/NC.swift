//
//  NC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class NC: UINavigationController, UINavigationBarDelegate {

    let backgroundImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for viewController in self.viewControllers {

            viewController.navigationItem.titleView = LogoV(frame: CGRect(x: 0, y: 0, width: 36, height: 36), image: UIImage(named: "chain")!)
        }
        navigationBar.setBackgroundImage(UIImage(color: CHAIN_BLUE), for: .default)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        viewController.navigationItem.titleView = LogoV(frame: CGRect(x: 0, y: 0, width: 36, height: 36), image: UIImage(named: "chain")!)
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(color: CHAIN_BLUE), for: .default)
    }

}
