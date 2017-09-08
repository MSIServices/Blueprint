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

    init(y: CGFloat = 0.0, height: CGFloat = 200) {
        super.init(frame: CGRect(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: height), style: .plain)
        
        separatorStyle = .none
        backgroundColor = UIColor.white
        register(SearchTV.nib(), forCellReuseIdentifier: SEARCH_TVC)
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
