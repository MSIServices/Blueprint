//
//  AudioVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class AudioVC: UIViewController {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var outerBtnV: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumTrackTintColor = CHAIN_CREAM
        slider.setThumbImage(UIImage(named: "up-arrow-cream"), for: .normal)
        
        outerBtnV.layer.cornerRadius = outerBtnV.frame.size.width / 2
        recordBtn.layer.cornerRadius = recordBtn.frame.size.width / 2
        
        recordBtn.layer.borderColor = UIColor.white.cgColor
        recordBtn.layer.borderWidth = 1.0
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: CHAIN_BLUE), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = nil
    }
    
    func backBtnPressed() {
        self.performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }

}
