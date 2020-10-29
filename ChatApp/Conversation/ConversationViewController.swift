//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var channel: Channel?
    private var messages = [Message]()
    
    let cellId = "\(IncommingMessageCell.self)"
    let cellId2 = "\(OutgoingMessageCell.self)"
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        guard let channel = self.channel else { return }
        guard let message = messageTextView.text else { return }
        guard message != "" else { return }
        
        FirebaseManager.shared.sendMessage(channelId: channel.identifier, message: message)
        self.messageTextView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = channel?.name
        
        chatTableView?.delegate = self
        chatTableView?.dataSource = self
        chatTableView?.register(UINib(nibName: String(describing: IncommingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IncommingMessageCell.self))
        chatTableView?.register(UINib(nibName: String(describing: OutgoingMessageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OutgoingMessageCell.self))
        
        loadMessages()
    }
    
    private func loadMessages() {
        FirebaseManager.shared.getMessages(channel: channel!) { (result) in
            switch result {
            case .success(let messages):
                self.messages = messages.sorted {
                    $0.created < $1.created
                }
                self.chatTableView.reloadData()
                self.scrollToBottom()
            case .failure: break
            }
        }
    }
    
    private func scrollToBottom(animated: Bool = true) {
        guard messages.count > 0 else { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
    }
    
}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let chatMessage = messages[indexPath.row]
      if chatMessage.senderId == FirebaseManager.shared.senderId {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as? OutgoingMessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        return cell
        
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? IncommingMessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        return cell
      }
    }
}

extension ConversationViewController: UITableViewDelegate {
}
