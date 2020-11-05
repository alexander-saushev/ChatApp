//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageAreaView: UIView!
    @IBOutlet weak var messageAreaBottomConstraint: NSLayoutConstraint!
    
    let IncommingMessageCellId = "\(IncommingMessageCell.self)"
    let OutgoingMessageCellId = "\(OutgoingMessageCell.self)"
    
    var channel: Channel_db!
    
    private var fetchedResultsController: NSFetchedResultsController<Message_db>!
    
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
        configKeyboard()
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        guard let channel = self.channel else { return }
        guard let message = messageTextView.text else { return }
        let visibleSymbols = NSCharacterSet.whitespacesAndNewlines.inverted
        let range = message.rangeOfCharacter(from: visibleSymbols)
        guard range != nil else { return }
        
        guard let identifier = channel.identifier else { return }
        FirebaseManager.shared.sendMessage(channelId: identifier, message: message)
        self.messageTextView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom(animated: true)
        super.viewDidAppear(animated)

    }
    
    private func loadMessages() {
      FirebaseManager.shared.getMessages(channel: channel)
      let request: NSFetchRequest<Message_db> = Message_db.fetchRequest()
      request.predicate = NSPredicate(format: "channel == %@", channel)
      let sortDescriptor = NSSortDescriptor(keyPath: \Message_db.created, ascending: true)
      request.sortDescriptors = [sortDescriptor]
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                            managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      try? self.fetchedResultsController.performFetch()
      self.fetchedResultsController.delegate = self
    }
    
    private func scrollToBottom(animated: Bool) {
        let count = chatTableView.numberOfRows(inSection: 0)
        if count > 0 {
            let lastIndex = IndexPath(row: count - 1, section: 0)
            chatTableView.scrollToRow(at: lastIndex, at: .top, animated: animated)
        }
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        self.messageAreaView.backgroundColor = Theme.current.profileHeaderColor
        self.messageTextView.backgroundColor = Theme.current.backgroundColor
        self.messageTextView.textColor = Theme.current.textColor
        view.backgroundColor = Theme.current.profileHeaderColor
    }
    
    private func configKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardScreenEndFrame: CGRect = keyboardValue.cgRectValue
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            messageAreaBottomConstraint?.constant = 0
        } else {
            messageAreaBottomConstraint?.constant = keyboardScreenEndFrame.height - (bottomPadding ?? 0)
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            self.scrollToBottom(animated: false)
        }
    }
}

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let chatMessage = fetchedResultsController.object(at: indexPath)
      if chatMessage.senderId == FirebaseManager.shared.senderId {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingMessageCellId, for: indexPath) as? OutgoingMessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: chatMessage)
        return cell
        
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IncommingMessageCellId, for: indexPath) as? IncommingMessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: chatMessage)
        return cell
      }
    }
}

extension ConversationViewController: UITableViewDelegate {
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    chatTableView.beginUpdates()
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    chatTableView.endUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    switch type {
    case .insert:
        chatTableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .update:
        chatTableView.reloadRows(at: [indexPath!], with: .automatic)
    case .move:
        chatTableView.deleteRows(at: [indexPath!], with: .automatic)
        chatTableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
        chatTableView.deleteRows(at: [indexPath!], with: .automatic)
    @unknown default:
      fatalError()
    }
  }
}
