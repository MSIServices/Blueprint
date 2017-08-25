//
//  NewPostVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/17/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController, CheckerOptionVDelegate {

    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let checkerOptionV = CheckerOptionV(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        checkerOptionV.checkerOptionD = self
        view.addSubview(checkerOptionV)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
            performSegue(withIdentifier: MEDIA_VC, sender: self)
        case 3:
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
