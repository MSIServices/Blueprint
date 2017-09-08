//
//  SearchTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/8/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addViewBackedBorder(side: .south, thickness: 1.0, color: UIColor.lightGray)
    }
    
    func configureCell() {
        
    }
    
}
