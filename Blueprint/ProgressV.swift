//
//  ProgressV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/25/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class ProgressV: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var progressBarV: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
        self.progressBarV.setProgress(0, animated: false)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let rect = self.bounds
        var isInside = rect.contains(point)
        if !isInside {
            for view in subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    class func nib() -> ProgressV {
        return UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProgressV
    }
    
    func updateProgress(bytesSent: Int64, bytesExpected: Int64) {
        
        print(progressBarV.progress)
        
        if progressBarV.progress != 1 {
            progressBarV.progress = Float(bytesSent) / Float(bytesExpected)
        } else {
            self.removeFromSuperview()
        }
    }

}
