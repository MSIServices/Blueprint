//
//  LinkVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import SwiftLinkPreview

fileprivate let HEADER_TVC = "HeaderTVC"
fileprivate let TEXT_FIELD_TVC = "TextFieldTVC"
fileprivate let PREVIEW_TVC = "PreviewTVC"
fileprivate let TEXT_VIEW_TVC = "TextViewTVC"

class LinkVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MessageDelegate {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBttm: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: UIButton!
    
    let slp = SwiftLinkPreview()
    
    var url: String?
    var message: String?
    var activeField: Int?
    var linkPreview: LinkPreview?
    var timer: Timer?
    var gettingPreview = false
    var previewCell: PreviewTVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(HeaderTVC.nib(), forCellReuseIdentifier: HEADER_TVC)
        tableView.register(TextFieldTVC.nib(), forCellReuseIdentifier: TEXT_FIELD_TVC)
        tableView.register(PreviewTVC.nib(), forCellReuseIdentifier: PREVIEW_TVC)
        tableView.register(TextViewTVC.nib(), forCellReuseIdentifier: TEXT_VIEW_TVC)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == RECIPIENT_VC {
            
            if var url = self.url, url.characters.count > 0 {
                
                if Regex.test(url, regex: Regex.rawUrlPattern) && (previewCell.previewImageView.image != UIImage(named: "no-preview") || !(previewCell.titleLbl.text?.isEmpty)!) {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == RECIPIENT_VC {
            
            let vC = segue.destination as! RecipientVC
            vC.type = PostType.text
            vC.link = url
            vC.text = message
            vC.previousVC = nameOfClass
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
                
                self.tableViewBttm.constant = keyboardSize.height - 60 - TAB_BAR_HEIGHT
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.tableViewBttm.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setActiveField(tag: Int) {
        activeField = tag
    }
    
    func updateText(text: String?) {
        message = text
    }
    
    func updateUrl(text: String?) {
        
        url = text
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getPreview), userInfo: nil, repeats: false)
    }
    
    func getPreview() {
        
            previewCell.previewImageView.image = UIImage(named: "no-preview")
            previewCell.titleLbl.text = ""
            previewCell.urlLbl.text = ""
            previewCell.loadingSpinner.isHidden = false
            previewCell.loadingSpinner.startAnimating()
            gettingPreview = true
        
            slp.previewLink(url, onSuccess: { result in
                
                self.previewCell.loadingSpinner.stopAnimating()
                self.previewCell.loadingSpinner.isHidden = true
                self.gettingPreview = false
                
                self.linkPreview = LinkPreview(icon: result["icon"] as? String, title: result["title"] as? String, descrip: result["descrip"] as? String, image: result["image"] as? String, images: result["images"] as? [String], canonicalUrl: result["canonicalUrl"] as? String, finalUrl: result["finalUrl"] as? URL, url: result["url"] as? String)
                
                if let urlString = self.linkPreview?.finalUrl {
                    self.url = String(describing: urlString)
                }
                
                self.tableView.reloadData()
                
            }, onError: { error in
                
                print(error)
                self.previewCell.loadingSpinner.stopAnimating()
                self.previewCell.loadingSpinner.isHidden = true
                self.gettingPreview = false
            })
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        } else if indexPath.section == 1 {
            return 300
        } else if indexPath.section == 2 {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_FIELD_TVC, for: indexPath) as! TextFieldTVC
            
            cell.configureCell(text: url)
            cell.messageDelegate = self
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PREVIEW_TVC, for: indexPath) as! PreviewTVC
            
            cell.configureCell(linkPreview: linkPreview)
            
            previewCell = cell
            
            return cell
        
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_VIEW_TVC, for: indexPath) as! TextViewTVC
            
            cell.configureCell(text: message)
            cell.messageDelegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let txtFieldPosition = textView.convert(textView.bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: txtFieldPosition)
        tableView.scrollToRow(at: indexPath!, at: .bottom, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: HEADER_TVC) as! HeaderTVC
        
        if section == 0 {
            header.configureCell(title: "Url", image: "link-cream")
        } else if section == 1 {
            header.configureCell(title: "Preview", image: "preview-cream")
        } else if section == 2 {
            header.configureCell(title: "Message", image: "message-cream")
        }
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 20
        }
        return 0.00000001
    }
    
    @IBAction func unwindToLinkVC(segue: UIStoryboardSegue) { }

}
