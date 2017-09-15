//
//  ConversationsVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/7/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

fileprivate let CONVERSATION_TVC = "ConversationTVC"

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var conversations = [ConversationCD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ConversationTVC.nib(), forCellReuseIdentifier: CONVERSATION_TVC)
        
        addBarButton(imageNormal: "new-message-white", imageHighlighted: "new-message-cream", action: #selector(goToMessages), side: .east)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.shared.
    }
    
    func goToMessages() {
        performSegue(withIdentifier: MESSAGES_VC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let convo = conversations[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: CONVERSATION_TVC, for: indexPath) as! ConversationTVC
        
        cell.configureCell(conversation: convo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func unwindToConversationsVC(segue: UIStoryboardSegue) { }
    
}
