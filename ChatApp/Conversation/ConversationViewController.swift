//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var messageService: MessageService?
    
    var channel: Channel?
    
    var messages: [Message] = []
    
    let cellId = "\(ConversationCell.self)"
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        guard let content = messageTextView.text else { return }
        self.messageTextView.text = ""
        messageService?.addMessage(
            content: content) { (result) in
            DispatchQueue.main.async {
                if case Result.failure(_) = result {
                    print("Не удалось отправить сообщение")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let channel = self.channel {
            messageService = MessageService(channel: channel)
        }
        
        setTheme()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = channel?.name
        
        chatTableView?.delegate = self
        chatTableView?.dataSource = self
        chatTableView?.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationCell.self))
        
        subscribeOnMessagesUpdates()
    }
    
    private func subscribeOnMessagesUpdates() {
        messageService?.subscribeOnMessages(handler: { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                    self?.chatTableView.reloadData()
                    self?.scrollToBottom()
                case .failure:
                    break
                }
            }
        })
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}
