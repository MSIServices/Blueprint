//
//  FeatureTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 10/2/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class FeatureTVC: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var feature: [Int:String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(feature: [Int:String]) {
        
        self.feature = feature
        self.titleLbl.text = feature[0]
        self.iconImageView.image = UIImage(named: feature[1]!)!
    }
    
}
