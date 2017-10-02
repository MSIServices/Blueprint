//
//  FeaturesVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 10/2/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let FEATURE_TVC = "FeatureTVC"

class FeaturesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var features: [[Int:String]] = [[0:"Apple Pay", 1: "apple-pay-black"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FeatureTVC.nib(), forCellReuseIdentifier: FEATURE_TVC)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feature = features[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FEATURE_TVC, for: indexPath) as! FeatureTVC
        
        cell.configureCell(feature: feature)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FeatureTVC
        
        switch cell.feature[0]! {
        case "Apple Pay":
            self.performSegue(withIdentifier: APPLE_PAY_VC, sender: self)
        default: break
        }
    }
    
    @IBAction func unwindToFeaturesVC(segue: UIStoryboardSegue) { }

}
