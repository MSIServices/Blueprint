//
//  MessagesVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let MESSAGE_TVC = "MessageTVC"
fileprivate let SEARCH_TVC = "SearchTVC"

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var textView: TV!
    
    var users = [UserCD]()
    var filteredUsers = [UserCD]()
    var recipients = [UserCD]()
    var messages = [MessageCD]()
    var bubbles = [(BubbleV, CGFloat)]()
    var conversation: ConversationCD?
    var searchTV: SearchTV!
    var bubbleHeight: CGFloat = 40
    var bubbleSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTV = SearchTV(y: messagesTableView.frame.origin.y)
        searchTV.delegate = self
        searchTV.dataSource = self
        searchTV.isHidden = true
        view.addSubview(searchTV)
        
        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if conversation == nil {
            getUsers()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
    }
    
    func getUsers() {
        
        APIManager.shared.getUsers(Success: { good in
            
            if good {
                self.users = UserCD.fetchAll()
            }
        }, Failure: { error in
            print(error ?? "No Error")
        })
    }
    
    func createBubble(user: UserCD) {
    
//        let widthOfText: CGFloat = user.username!.trimmingCharacters(in: .whitespaces).width(height: bubbleHeight, font: searchField.font!)
//        let bubbleV: BubbleV = BubbleV(textField: searchField, user: user, widthOfText: widthOfText, height: bubbleHeight, spacing: bubbleSpacing, font: UIFont(name: "OpenSans-Bold", size: 12.0)!)
//        bubbles.append((bubbleV, widthOfText + (bubbleSpacing * 2)))
//        searchField.text = ""
//        searchTV.isHidden = true
    }
    
    func keyboardWillShow(_ notification: Notification) {
    
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    
            if view.frame.origin.y == 0 {
        
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        
//        if let txt = textField.text, textField == searchField, textField.text != "" {
//            
//            print(searchFieldWidth.constant)
//            
//            if txt.width(height: textField.bounds.size.height, font: searchField.font!) > UIScreen.main.bounds.size.width {
//                searchFieldWidth.constant = txt.width(height: textField.bounds.size.height, font: searchField.font!)
//            }
//            
//            filteredUsers = users.filter { $0.username?.lowercased().range(of: txt.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) != nil && $0.username != UserDefaults.standard.value(forKey: USERNAME) as? String && !recipients.contains($0) }
//            
//            if filteredUsers.count > 0 {
//                searchTV.isHidden = false
//                searchTV.reloadData()
//            }
//            
//            for user in filteredUsers {
//                
//                if user.username!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == txt.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) && !recipients.contains { $0.username == user.username! } {
//                    
//                    self.recipients.append(user)
//                    self.createBubble(user: user)
//                    return
//                }
//            }
//        } else {
//            filteredUsers.removeAll()
//            searchTV.isHidden = true
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchTV {
            return users.count
        }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == searchTV {
            return 50
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == messagesTableView {
            
            if messages.count > 0 {
                
                let msg = messages[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_TVC, for: indexPath) as! MessageTVC
                
                cell.configureCell(msg: msg)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_CONVERSATIONS_VC, sender: self)
    }
    
    @IBAction func addRecipientBtnPressed(_ sender: Any) {
        
        
    }

}
