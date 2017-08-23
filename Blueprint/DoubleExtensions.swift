//
//  DoubleExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

extension Double {
    
    func ToPercent(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 0) -> String {
        
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.multiplier = 1.0
        percentFormatter.minimumFractionDigits = minimumFractionDigits
        percentFormatter.maximumFractionDigits = maximumFractionDigits
        return percentFormatter.string(from: NSNumber(value: self * 100))!
    }

}
