//
//  ConversationsListCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with model: Channel_db) {
        self.selectionStyle = .none
        
        setTheme()
        
        photoView.layer.cornerRadius = photoView.bounds.width / 2
        nameLabel.text = model.name
        
        if model.lastMessage == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 14)
            dateLabel.text = ""
        } else {
            messageLabel?.font = .none
            messageLabel.text = model.lastMessage
            dateLabel?.text = formDate(model.lastActivity ?? Date())
        }
    }
    
    private func formDate(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let localDate = dateFormatter.string(from: date)
            return localDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
    }
    
    private func setTheme() {
        nameLabel?.textColor = Theme.current.textColor
        messageLabel?.textColor = Theme.current.conversationsListTextColor
        dateLabel?.textColor = Theme.current.conversationsListTextColor
    }
}
