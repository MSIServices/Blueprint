//
//  MediaVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/23/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let placeholderText = "Text"

class MediaVC: UIViewController, UITextViewDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var textView: TV!
    
    var imagePath: NSURL?
    var newImageIdentifier: String?
    var ext: String?
    var type: PostType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        addBarButton(imageNormal: "camera-white", imageHighlighted: nil, action: #selector(showMediaLibrary), side: .east)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.addViewBackedBorder(side: .south, thickness: 1.0, color: UIColor.lightGray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == RECIPIENT_VC {
            
            let vC = segue.destination as! RecipientVC
            vC.previousVC = MEDIA_VC
            vC.type = type
            vC.ext = ext
            vC.imageUrl = imagePath
            vC.imageLocalIdentifier = newImageIdentifier
            
            if let txt = textView.text {
                vC.text = txt
            }
        } else if segue.identifier == MEDIA_LIBRARY_VC {
            
            let vC = segue.destination as! MediaLibraryVC
            vC.type = type
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String) {
        
        aTextview.textColor = UIColor.gray
        aTextview.text = placeholderText
        aTextview.textAlignment = .center
        aTextview.font = UIFont(name: "OpenSans-LightItalic", size: 16)!
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView) {
        
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
        aTextview.textAlignment = .left
        aTextview.font = UIFont(name: "OpenSans-Regular", size: 16)!
    }
    
    func textViewShouldBeginEditing(_ aTextView: UITextView) -> Bool {
        
        if aTextView.text == placeholderText {
            moveCursorToStart(aTextView: aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView) {

        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            
            textView.resignFirstResponder()
            return false
        }
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        if newLength > 0 {
            
            if textView.text == placeholderText {
                
                if text.utf16.count == 0 {
                    return false
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
            
        } else {
            
            applyPlaceholderStyle(aTextview: textView, placeholderText: placeholderText)
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    func showMediaLibrary() {
        performSegue(withIdentifier: MEDIA_LIBRARY_VC, sender: self)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if mediaImageView.image != nil && mediaImageView.image != UIImage(named: "no-preview") {
            performSegue(withIdentifier: RECIPIENT_VC, sender: self)
        }
    }

    @IBAction func unwindToMediaVC(segue: UIStoryboardSegue) { }

}
