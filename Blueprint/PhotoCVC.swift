//
//  PhotoCVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class PhotoCVC: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        photoImageView.backgroundColor = UIColor.random()
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 4.0
            } else {
                layer.borderWidth = 0.0
            }
            super.isHighlighted = newValue
        }
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(image: UIImage) {
        photoImageView.image = image
    }

}
