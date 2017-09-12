//
//  Helper.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/9/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

struct Helper {
    
    static func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
            
    static func generateRandomBytes() -> [UInt8] {
        
        var bytes = [UInt8]()
        
        for _ in 1...32 {
            bytes.append(UInt8(arc4random_uniform(255)))
        }
        return bytes
    }
    
    static func formatTimeIntervalWithMinutesAndSeconds(currentTime: TimeInterval) -> String {
        
        let dFormat = "%02d"
        let min: Int = Int(currentTime / 60)
        let sec: Int = Int(currentTime.truncatingRemainder(dividingBy: 60.0))
        
        return "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
    }
    
    static func findFirstResponder(inView view: UIView) -> UIView? {
        
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }

}
