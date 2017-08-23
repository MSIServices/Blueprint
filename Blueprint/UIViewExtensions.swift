//
//  UIViewExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setLoadingSpinner(image: String) -> UIImageView {
        
        let spinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        spinner.image = UIImage(named: image)
        spinner.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        spinner.startRotating()
        self.addSubview(spinner)
        
        return spinner
    }
    
    func startRotating(duration: Double = 1) {
        
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    func renderDark(animated: Bool, duration: TimeInterval = 0.25) -> UIView {
        
        let darkView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0
        
        if animated {
            UIView.animate(withDuration: duration, animations: {
                darkView.alpha = 0.6
            })
        } else {
            darkView.alpha = 0.6
        }
        self.addSubview(darkView)
        
        return darkView
    }
    
    func addButtonSlider(button: UIButton, color: UIColor, numberOfButtons: CGFloat, height: CGFloat = 5) -> UIView {
        
        let slider = UIView(frame: CGRect(x: 0, y: button.bounds.size.height - height, width: UIScreen.main.bounds.size.width / numberOfButtons, height: height))
        slider.backgroundColor = color
        self.addSubview(slider)
        
        return slider
    }
    
    func createBorder(side: Direction, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
        
        switch side {
        case .north:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .east:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .south:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .west:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        default: break
        }
        return CALayer()
    }
    
    func createViewBackedBorder(side: Direction, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
        
        switch side {
        case .north:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .east:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
            
        case .south:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .west:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        default: break
        }
        return UIView()
    }
    
    func addBorder(side: Direction, thickness: CGFloat, color: UIColor, borderAdjustment: CGFloat, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .north:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset,
                                                                   height: thickness), color: color)
            self.layer.addSublayer(border)
        case .east:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                   y: 0 + topOffset, width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        case .south:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: self.frame.size.height-thickness-bottomOffset,
                                                                   width: self.frame.size.width + borderAdjustment - leftOffset - rightOffset, height: thickness), color: color)
            self.layer.addSublayer(border)
        case .west:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        default: break
        }
    }
    
    func addViewBackedBorder(side: Direction, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .north:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .east:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
            
        case .south:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .west:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        default: break
        }
    }
    
    //////////
    // Private: Our methods call these to add their borders.
    //////////
    
    
    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border: UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }

}
