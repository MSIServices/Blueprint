//
//  HomeVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/16/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import SwiftyGif

class HomeVC: UIViewController, SwiftyGifDelegate {
    
    @IBOutlet var mainV: MainV!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
