//
//  UIImageExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }

}
