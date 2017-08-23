//
//  MainVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var topBtn: CustomB!
    @IBOutlet weak var btmBtn: CustomB!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBtn.setTitleColor(CHAIN_CREAM, for: .normal)
        topBtn.setBorderWithColor(color: CHAIN_CREAM, borderWidth: 2)
        
        btmBtn.setTitleColor(CHAIN_BLUE, for: .normal)
        btmBtn.backgroundColor = CHAIN_CREAM
        btmBtn.setCornerRadius(num: 3.0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: USER_ID) as? Int != nil {
            performSegue(withIdentifier: HOME_VC, sender: self)
        }
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) { }

}
