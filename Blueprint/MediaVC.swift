//
//  MediaVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class MediaVC: UIViewController {

    
    @IBOutlet var mainV: MainV!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var textView: TV!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        addBarButton(imageNormal: "camera-white", imageHighlighted: nil, action: #selector(showMediaLibrary), side: .east)
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    func showMediaLibrary() {
        performSegue(withIdentifier: MEDIA_LIBRARY_VC, sender: self)
    }

    @IBAction func unwindToMediaVC(segue: UIStoryboardSegue) { }

}
