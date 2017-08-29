//
//  MainV.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/12/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class MainV: UIView {

    var darkView: UIView!
    var singleActionAlertV: SingleActionAlertV!
    var doubleActionAlertV: DoubleActionAlertV!
    var zeroActionAlertV: ZeroActionAlertV!
    var progressV: ProgressV!
    
    func removeAlert() {
        
        if darkView != nil {
            darkView.removeFromSuperview()
            darkView = nil
        }
        if progressV != nil {
            progressV.removeFromSuperview()
            progressV = nil
        }
        if zeroActionAlertV != nil {
            zeroActionAlertV.removeFromSuperview()
            zeroActionAlertV = nil
        }
        if singleActionAlertV != nil {
            singleActionAlertV.removeFromSuperview()
            singleActionAlertV = nil
        }
        if doubleActionAlertV != nil {
            doubleActionAlertV.removeFromSuperview()
            doubleActionAlertV = nil
        }
    }
    
    func showProgressV(height: CGFloat = 240, width: CGFloat = 240, animated: Bool) -> ProgressV {
        
        if self.progressV == nil {
            
            progressV = ProgressV.nib()
            progressV.frame = CGRect(x: 0, y: 0, width: width, height: height)
            progressV.center.x = self.bounds.size.width / 2
            self.addSubview(progressV)
            
            if animated {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.progressV.center.y = self.bounds.size.height / 2 - 50
                }, completion: { result in
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.progressV.center.y -= 10
                    })
                })
            } else {
                progressV.center = CGPoint(x: self.bounds.size.width / 2, y: (self.bounds.size.height / 2) - 60)
            }
            return progressV
        }
        return progressV
    }
    
    //For use with GIF's
    func showZeroActionAlert(gif: String, header: String, subHeader: String, backgroundColor: UIColor, animated: Bool) -> ZeroActionAlertV {
        
        if self.zeroActionAlertV == nil {
            
            darkView = self.renderDark(animated: animated)
            self.addSubview(darkView!)
            
            zeroActionAlertV = ZeroActionAlertV.nib()
            zeroActionAlertV.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
            zeroActionAlertV.center.y = -(zeroActionAlertV?.frame.size.height)!
            zeroActionAlertV.center.x = self.bounds.size.width / 2
            zeroActionAlertV.isHidden = false
            zeroActionAlertV.configureView(gif: gif, header: header, subHeader: subHeader, backgroundColor: backgroundColor)
            self.addSubview(zeroActionAlertV!)
            
            if animated {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.zeroActionAlertV.center.y = self.bounds.size.height / 2 - 50
                }, completion: { result in
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.zeroActionAlertV.center.y -= 10
                    })
                })
            } else {
                zeroActionAlertV.center = CGPoint(x: self.bounds.size.width / 2, y: (self.bounds.size.height / 2) - 60)
            }
            return zeroActionAlertV
        }
        return zeroActionAlertV
    }
    
    func showSingleActionAlert(icon: String, header: String, subHeader: String, btnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor, animated: Bool) -> SingleActionAlertV {
        
        if self.singleActionAlertV == nil {
            
            darkView = self.renderDark(animated: animated)
            self.addSubview(darkView!)
            
            singleActionAlertV = SingleActionAlertV.nib()
            singleActionAlertV.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
            singleActionAlertV.center.y = -(singleActionAlertV?.frame.size.height)!
            singleActionAlertV.center.x = self.bounds.size.width / 2
            singleActionAlertV.isHidden = false
            singleActionAlertV.configureView(image: icon, header: header, subHeader: subHeader, btnText: btnText, backgroundColor: backgroundColor, buttonNormalBackgroundColor: buttonNormalBackgroundColor, buttonHighlightedBackgroundColor: buttonHighlightedBackgroundColor)
            self.addSubview(singleActionAlertV!)
            
            if animated {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.singleActionAlertV.center.y = self.bounds.size.height / 2 - 50
                }, completion: { result in

                    UIView.animate(withDuration: 0.25, animations: {
                        self.singleActionAlertV.center.y -= 10
                    })
                })
            } else {
                singleActionAlertV.center = CGPoint(x: self.bounds.size.width / 2, y: (self.bounds.size.height / 2) - 60)
            }
            return singleActionAlertV
        }
        return singleActionAlertV
    }
    
    //For use with GIF's
    func showSingleActionAlert(gif: String, header: String, subHeader: String, btnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor, animated: Bool) -> SingleActionAlertV {
        
        if self.singleActionAlertV == nil {
            
            darkView = self.renderDark(animated: animated)
            self.addSubview(darkView!)
            
            singleActionAlertV = SingleActionAlertV.nib()
            singleActionAlertV.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
            singleActionAlertV.center.y = -(singleActionAlertV?.frame.size.height)!
            singleActionAlertV.center.x = self.bounds.size.width / 2
            singleActionAlertV.isHidden = false
            singleActionAlertV.configureView(gif: gif, header: header, subHeader: subHeader, btnText: btnText, backgroundColor: backgroundColor, buttonNormalBackgroundColor: buttonNormalBackgroundColor, buttonHighlightedBackgroundColor: buttonHighlightedBackgroundColor)
            self.addSubview(singleActionAlertV)
            
            if animated {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.singleActionAlertV.center.y = self.bounds.size.height / 2 - 50
                }, completion: { result in
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.singleActionAlertV.center.y -= 10
                    })
                })
            } else {
                singleActionAlertV.center = CGPoint(x: self.bounds.size.width / 2, y: (self.bounds.size.height / 2) - 60)
            }
            return singleActionAlertV
        }
        return singleActionAlertV
    }
    
    func showDoubleActionAlert(height: CGFloat = 300, width: CGFloat = 300, header: String, subHeader: String, cancelBtnText: String, confirmationBtnText: String, backgroundColor: UIColor, buttonNormalBackgroundColor: UIColor, buttonHighlightedBackgroundColor: UIColor, icon: String?, animated: Bool) -> DoubleActionAlertV {
        
        if self.doubleActionAlertV == nil {
            
            darkView = self.renderDark(animated: animated)
            self.addSubview(darkView!)
            
            doubleActionAlertV = DoubleActionAlertV.nib()
            doubleActionAlertV.frame = CGRect(x: 0, y: 0, width: width, height: height)
            doubleActionAlertV.center.y = -(doubleActionAlertV.frame.size.height)
            doubleActionAlertV.center.x = self.bounds.size.width / 2
            doubleActionAlertV.isHidden = false
            doubleActionAlertV.confirmationBtn.addButtonDivider(width: 1.0, color: UIColor.lightText)
            doubleActionAlertV.configureView(image: icon, header: header, subHeader: subHeader, leftBtnText: cancelBtnText, rightBtnText: confirmationBtnText, backgroundColor: backgroundColor, buttonNormalBackgroundColor: buttonNormalBackgroundColor, buttonHighlightedBackgroundColor: buttonHighlightedBackgroundColor)
            self.addSubview(doubleActionAlertV)
            
            if animated {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.doubleActionAlertV.center.y = self.bounds.size.height / 2 - 50
                }, completion: { result in
                  
                    UIView.animate(withDuration: 0.25, animations: {
                        self.doubleActionAlertV.center.y -= 10
                    })
                })
            } else {
                doubleActionAlertV.center = CGPoint(x: self.bounds.size.width / 2, y: (self.bounds.size.height / 2) - 60)
            }
            return doubleActionAlertV
        }
        return doubleActionAlertV
    }
    
    func showError(msg: String, animated: Bool) -> SingleActionAlertV {
        return showSingleActionAlert(icon: "error-white", header: "Error", subHeader: msg, btnText: "Ok", backgroundColor: ERROR, buttonNormalBackgroundColor: ERROR_BUTTON, buttonHighlightedBackgroundColor: ERROR_BUTTON_HIGHLIGHT, animated: true)
    }
    
    func showSuccess(msg: String, animated: Bool) -> ZeroActionAlertV {
        return showZeroActionAlert(gif: "green-checkmark-animated.gif", header: "Success", subHeader: msg, backgroundColor: UIColor.white, animated: true)
    }
    
}
