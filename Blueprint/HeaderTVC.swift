//
//  HeaderTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class HeaderTVC: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }

    func configureCell(title: String, image: String) {
        
        headerLbl.text = title
        iconImageView.image = UIImage(named: image)
    }
    
}
