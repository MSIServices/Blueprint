//
//  LogoV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/11/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class LogoV: UIView {

    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.frame = frame
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imageView)
        self.clipsToBounds = true
        imageView.center = (imageView.superview?.center)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
