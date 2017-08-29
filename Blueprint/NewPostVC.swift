//
//  NewPostVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/17/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {
    
    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func textBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TEXT_VC, sender: self)
    }
    
    @IBAction func linkBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: LINK_VC, sender: self)
    }
    
    @IBAction func imageBtnPressed(_ sender: Any) {
        self.tag = 2
        performSegue(withIdentifier: MEDIA_VC, sender: self)
    }
    
    @IBAction func videoBtnPressed(_ sender: Any) {
        self.tag = 3
        performSegue(withIdentifier: MEDIA_VC, sender: self)
    }
    
    @IBAction func microphoneBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: AUDIO_VC, sender: self)
    }
    
    @IBAction func quoteBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: QUOTE_VC, sender: self)
    }
    
    @IBAction func unwindToNewPostVC(segue: UIStoryboardSegue) { }
    
}
