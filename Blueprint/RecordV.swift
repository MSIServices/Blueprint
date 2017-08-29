//
//  RecordV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class RecordV: UIView {
    
    @IBOutlet weak var middleV: UIView!
    @IBOutlet weak var innerV: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var middleVHeight: NSLayoutConstraint!
    @IBOutlet weak var middleVWidth: NSLayoutConstraint!
    @IBOutlet weak var innerVHeight: NSLayoutConstraint!
    @IBOutlet weak var innerVWidth: NSLayoutConstraint!
    @IBOutlet weak var recordBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var recordBtnHeight: NSLayoutConstraint!
    
    var developmentSize: CGFloat = 200
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.size.width / 2
        middleV.layer.cornerRadius = middleV.frame.size.width / 2
        innerV.layer.cornerRadius = innerV.frame.size.width / 2
        recordBtn.layer.cornerRadius = recordBtn.frame.size.width / 2
    }
    
    class func nib() -> RecordV {
        return UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RecordV
    }
    
    func scale(size: CGFloat) {
        
        let scale = size / developmentSize
        
        middleVHeight.constant = middleVHeight.constant * scale
        middleVWidth.constant = middleVWidth.constant * scale
        innerVHeight.constant = innerVHeight.constant * scale
        innerVWidth.constant = innerVWidth.constant * scale
        recordBtnWidth.constant = recordBtnWidth.constant * scale
        recordBtnHeight.constant = recordBtnHeight.constant * scale
    }
    
    func setColors(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        
        self.backgroundColor = colorOne
        middleV.backgroundColor = colorTwo
        innerV.backgroundColor = colorThree
    }

}
