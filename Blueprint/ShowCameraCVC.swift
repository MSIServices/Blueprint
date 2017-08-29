//
//  ShowCameraCVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class ShowCameraCVC: UICollectionViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    let developmentSize: CGFloat = 80.0
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(text: String, image: String) {
        self.iconImageView.image = UIImage(named: image)
        self.titleLbl.text = text
    }

}
