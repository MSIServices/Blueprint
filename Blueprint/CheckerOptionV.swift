//
//  CheckerOptionV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/17/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let IMAGE_INSETS: CGFloat = 40.0

class CheckerOptionV: UIView {
    
    var checkerOptionD: CheckerOptionVDelegate!

    private var _navBar: Bool = true
    private var _tabBar: Bool = true
    private var _columns: Int = 2
    private var _rows: Int = 3
    private var _icons = ["text-black","link-black","image-black","video-black","mic-black","quote-black"]
    private var _labels = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureImageOnly()
        
        center = (superview?.center)!
    }
    
    class func nib() -> CheckerOptionV {
        return UINib(nibName: self.nameOfClass, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CheckerOptionV
    }
    
    func configureImageOnly() {
        
        var height: CGFloat!
        
        if !_navBar && !_tabBar {
            height = (bounds.size.height) / CGFloat(_rows)
        } else if _navBar && !_tabBar {
            height = (bounds.size.height - NAVIGATION_BAR_HEIGHT) / CGFloat(_rows)
        } else if !_navBar && _tabBar {
            height = (bounds.size.height - TAB_BAR_HEIGHT) / CGFloat(_rows)
        } else if _navBar && _tabBar {
            height = (bounds.size.height - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT) / CGFloat(_rows)
        }
        
        var yOffset: CGFloat = 0.0
        var xOffset: CGFloat = 0.0
        var counter: Int = 0
        
        for rIdx in 0..._rows - 1 {
            
            xOffset = 0.0
            
            if rIdx == 0 && _navBar {
                yOffset = NAVIGATION_BAR_HEIGHT
            } else {
                yOffset += height
            }
            
            for _ in 0..._columns - 1 {
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: xOffset, y: yOffset, width: self.frame.size.width / CGFloat(_columns), height: height)
                button.setImage(UIImage(named: _icons[counter]), for: .normal)
//                button.imageEdgeInsets = UIEdgeInsets(top: IMAGE_INSETS, left: IMAGE_INSETS, bottom: IMAGE_INSETS, right: IMAGE_INSETS)
                button.tag = counter
                button.addTarget(self, action: #selector(btnPressed(button:)), for: .touchUpInside)
                addSubview(button)
                
                xOffset += self.frame.size.width / CGFloat(_columns)
                counter += 1
            }
        }
    }
    
    func btnPressed(button: UIButton) {
        checkerOptionD.checkerBtnPressed(tag: button.tag)
    }
    
}
