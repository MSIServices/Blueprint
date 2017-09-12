//
//  SearchTV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/8/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let SEARCH_TVC = "SearchTVC"

class SearchTV: UITableView {

    init(superview: UIView, topView: UIView, bottomView: UIView) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0), style: .plain)
        
        separatorStyle = .none
        backgroundColor = UIColor.white
        register(SearchTV.nib(), forCellReuseIdentifier: SEARCH_TVC)
        
        superview.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
}
