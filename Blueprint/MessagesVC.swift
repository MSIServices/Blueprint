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
fileprivate var placeholderText = "Enter Message"

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var searchTextView: TV!
    @IBOutlet weak var searchTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var addFileBtn: UIButton!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var sendMessageTextView: TV!
    @IBOutlet weak var sendMessageViewBttm: NSLayoutConstraint!
    @IBOutlet weak var messagesTableViewBttm: NSLayoutConstraint!

    var addRecipientBtn: UIButton!
    var users = [UserCD]()
    var filteredUsers = [UserCD]()
    var recipients = [UserCD]()
//    var participants = [UserCD]()
//    var messages = [MessageCD]()
    var bubbles = [(BubbleV, UIEdgeInsets)]()
    var conversation: ConversationCD?
    var bubbleHeight: CGFloat = 35
    var bubbleSpacing: CGFloat = 10
    var centerOffset: CGFloat = 0
    var originalSearchViewHeight: CGFloat!
    var currentLine = 1
    var maxNumberOfLines = 5
    var numberOfBubblesOnEachLine = [Int]()
    var firstLine = true
    var searchMode = false
    var removeBubble = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyPlaceholderStyle(aTextview: sendMessageTextView, placeholderText: placeholderText)
        
        addRecipientBtn = UIButton(type: .custom)
        addRecipientBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addRecipientBtn.frame.origin.x = view.frame.size.width - addRecipientBtn.bounds.size.width - 8
        addRecipientBtn.center.y = searchTextView.frame.size.height / 2
        addRecipientBtn.setImage(UIImage(named: "plus-black"), for: .normal)
        
        searchTextView.addSubview(addRecipientBtn)
        searchTextView.recipientV = true
        
        sendMessageTextView.layer.cornerRadius = 3
        
        centerOffset = searchTextViewHeight.constant / 2
        originalSearchViewHeight = searchTextView.bounds.size.height
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.register(SearchTVC.nib(), forCellReuseIdentifier: SEARCH_TVC)
        messagesTableView.register(MessageTVC.nib(), forCellReuseIdentifier: MESSAGE_TVC)
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 50
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backspacePressed), name: Notifications.customNotification.BackspaceDetected, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if conversation == nil {
            getUsers()
        } else {
            
            APIManager.shared.getConversation(conversationId: conversation!.conversationId!, Success: { conversation in
            
                self.conversation = conversation
                self.messagesTableView.reloadData()
                
            }, Failure: { error in
                print(error)
            })
        }
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String) {
        
        if aTextview == sendMessageTextView {
            
            aTextview.textColor = UIColor.gray
            aTextview.text = placeholderText
            aTextview.textAlignment = .left
            aTextview.font = UIFont(name: "OpenSans-LightItalic", size: 16)!
        }
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView) {
        
        if aTextview == sendMessageTextView {
            
            aTextview.textColor = UIColor.darkText
            aTextview.alpha = 1.0
            aTextview.textAlignment = .left
            aTextview.font = UIFont(name: "OpenSans-Regular", size: 16)!
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == placeholderText {
            moveCursorToStart(aTextView: textView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView) {
        
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    //Just look at it!
    func createBubble(user: UserCD) {
        
        let widthOfText: CGFloat = user.username!.trimmingCharacters(in: .whitespaces).width(height: bubbleHeight, font: searchTextView.font!)
        let potentialXPosition = searchTextView.xAdjustment + widthOfText
        
        if potentialXPosition > addRecipientBtn.frame.origin.x && currentLine == 1 {
            
            searchTextView.yAdjustment += originalSearchViewHeight
            searchTextView.xAdjustment = 5
            centerOffset += originalSearchViewHeight
            
            if currentLine != maxNumberOfLines {
                searchTextViewHeight.constant += originalSearchViewHeight
                searchTextView.isScrollEnabled = false
            }
            currentLine += 1
        } else if potentialXPosition > view.frame.size.width {
            
            if currentLine != maxNumberOfLines {
                searchTextViewHeight.constant += originalSearchViewHeight
                searchTextView.isScrollEnabled = false
            } else {
                searchTextView.text = ""
                return
            }
            searchTextView.yAdjustment += originalSearchViewHeight
            searchTextView.xAdjustment = 5
            centerOffset += originalSearchViewHeight
            currentLine += 1
        }
        
        let bubbleV: BubbleV = BubbleV(textView: searchTextView, user: user, widthOfText: widthOfText, height: bubbleHeight, spacing: bubbleSpacing, font: UIFont(name: "OpenSans-Bold", size: 12.0)!, centerOffset: centerOffset)
        bubbles.append((bubbleV, searchTextView.getCurrentInsets()))
        
        if numberOfBubblesOnEachLine.count != currentLine {
            numberOfBubblesOnEachLine.append(1)
        } else {
            numberOfBubblesOnEachLine[currentLine - 1] += 1
        }
        self.searchTextView.xAdjustment += widthOfText + bubbleSpacing
        self.searchTextView.textContainerInset = searchTextView.getCurrentInsets()
        self.searchTextView.text = ""
        self.recipients.append(user)
        disableSearch()
    }
    
    func backspacePressed() {
        
        if searchTextView.text == "" && bubbles.count > 0 && removeBubble {
            
            disableSearch()
            
            bubbles.last!.0.removeFromSuperview()
            searchTextView.textContainerInset = bubbles.last!.1
            searchTextView.xAdjustment = bubbles.last!.1.left
            searchTextView.yAdjustment = bubbles.last!.1.top
            bubbles.removeLast(1)
            recipients.removeLast(1)
            numberOfBubblesOnEachLine[currentLine - 1] -= 1
            
            if numberOfBubblesOnEachLine[currentLine - 1] == 0 && currentLine != 1 {
                
                centerOffset -= originalSearchViewHeight
                numberOfBubblesOnEachLine.remove(at: currentLine - 1)
                currentLine -= 1
                
                if currentLine <= 5 {
                    searchTextViewHeight.constant -= originalSearchViewHeight
                }
            }
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let activeField = Helper.findFirstResponder(inView: view) as! UITextView
        
        if activeField == sendMessageTextView {
            
            if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                if view.frame.origin.y == 0 {
                    
                    sendMessageViewBttm.constant = keyboardSize.height - TAB_BAR_HEIGHT
                    
                    UIView.animate(withDuration: 0.25) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        sendMessageViewBttm.constant = 0

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.endEditing(true)
            sendMessageViewBttm.constant = 0
        }
        
        if searchTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 1 {
            removeBubble = false
        } else {
            removeBubble = true
        }
        
        if textView == sendMessageTextView {
            
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
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {

        if let txt = textView.text, textView == searchTextView, textView.text != "" {
        
            filteredUsers = users.filter { $0.username?.lowercased().range(of: txt.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) != nil && $0.username != UserDefaults.standard.value(forKey: USERNAME) as? String && !recipients.contains($0) }
    
            if filteredUsers.count > 0 {
                
                enableSearch()
                
                for user in filteredUsers {
                    
                    if user.username!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == txt.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) && !recipients.contains { $0.username == user.username! } {
                        
                        self.createBubble(user: user)
                        return
                    }
                }
            } else {
                disableSearch()
            }
        } else {
            disableSearch()
        }
    }
    
    func enableSearch() {
        
        searchMode = true
        messagesTableView.bounces = false
        messagesTableView.reloadData()
    }
    
    func disableSearch() {
        
        filteredUsers.removeAll()
        searchMode = false
        messagesTableView.bounces = true
        messagesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchMode {
            return users.count
        }
        if conversation != nil {
            return conversation!.messages!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if searchMode {
            return 50
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchMode {
            
            let user = users[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SEARCH_TVC, for: indexPath) as! SearchTVC
            
            cell.configureCell(user: user)
            
            return cell
            
        } else {
            
            if conversation!.messages!.count > 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_TVC, for: indexPath) as! MessageTVC
                
                let messages: [MessageCD] = Array(conversation!.messages!) as! [MessageCD]
                let sortedMessages = messages.sorted {$0.timestamp?.compare($1.timestamp! as Date) == .orderedAscending}
                let msg = sortedMessages[indexPath.row]

                var showDate: Bool!
                var previousMsg: MessageCD!
                
                if indexPath.row == 0 {
                    showDate = true
                } else {
                    
                    previousMsg = sortedMessages[indexPath.row - 1]
                    if (msg.timestamp?.minutes(from: previousMsg.timestamp! as Date))! > 15 {
                        showDate = true
                    } else {
                        showDate = false
                    }
                }
                
                cell.configureCell(message: msg, showDate: showDate)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_CONVERSATIONS_VC, sender: self)
    }
    
    @IBAction func sendMessageBtnPressed(_ sender: Any) {
        
        if let msg = sendMessageTextView.text, msg != placeholderText {
            
            if conversation == nil && recipients.count > 0 {
                    
                var recipientIds: [NSNumber] = recipients.map { $0.userId! }
                recipientIds.append(User.currentId)
                
                APIManager.shared.getConversationFromRecipients(recipients: recipientIds, Success: { conversation in
                    
                    if conversation != nil {
                        
                        print("Conversation already exists")
                        //SAVE MESSAGE TO EXISTING CONVERSATION
                        
                        self.conversation = conversation
                        self.messagesTableView.reloadData()
                        
                    } else {
                        
                        print("Conversation does not exist. Creating new one...")
                        
                        APIManager.shared.createConversation(message: msg, recipients: recipientIds, Success: { conversation in
                            
                            self.conversation = conversation
                            self.applyPlaceholderStyle(aTextview: self.sendMessageTextView, placeholderText: placeholderText)
                            self.messagesTableView.reloadData()
                            
                        }, Failure: { error in
                            print(error ?? "No Error.")
                        })
                    }
                }, Failure: { error in
                    print(error ?? "No Error")
                })
            } else if conversation != nil {
//                saveMessage(conversation: conversation!, msg: msg)
            }
        }
    }
    
    @IBAction func addFileBtnPressed(_ sender: Any) {
        
    }
    
}
