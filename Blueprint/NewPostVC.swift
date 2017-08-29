//
//  NewPostVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/17/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController, CheckerOptionVDelegate {
    
    var checkerOptionV: CheckerOptionV!
    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkerOptionV = CheckerOptionV(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        checkerOptionV.checkerOptionD = self
        
        let topConstraint = NSLayoutConstraint(item: checkerOptionV, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 1.0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: checkerOptionV, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 1.0)
        bottomConstraint.isActive = true
        let leftConstraint = NSLayoutConstraint(item: checkerOptionV, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 1.0)
        leftConstraint.isActive = true
        let rightConstraint = NSLayoutConstraint(item: checkerOptionV, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 1.0)
        rightConstraint.isActive = true
        
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        view.addSubview(checkerOptionV)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == MEDIA_VC {
            
            let vC = segue.destination as! MediaVC
            
            if tag == 2 {
                vC.type = PostType.image
            } else if tag == 3 {
                vC.type = PostType.video
            }
        }
    }
        
    func checkerBtnPressed(tag: Int) {

        switch tag {
        case 0:
            performSegue(withIdentifier: TEXT_VC, sender: self)
        case 1:
            performSegue(withIdentifier: LINK_VC, sender: self)
        case 2:
            self.tag = 2
            performSegue(withIdentifier: MEDIA_VC, sender: self)
        case 3:
            self.tag = 3
            performSegue(withIdentifier: MEDIA_VC, sender: self)
        case 4:
            performSegue(withIdentifier: AUDIO_VC, sender: self)
        case 5:
            performSegue(withIdentifier: QUOTE_VC, sender: self)
        default:
            break
        }
    }
    
    @IBAction func unwindToNewPostVC(segue: UIStoryboardSegue) { }
    
}
