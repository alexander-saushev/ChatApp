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
    
    
    func configure(with model: ConversationCellModel) {
        self.selectionStyle = .none
        
        photoView.layer.cornerRadius = photoView.bounds.width / 2
        dateLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.6)
        nameLabel.text = model.name
        
        if model.message == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = .italicSystemFont(ofSize: 14)
            dateLabel.text = ""
        } else {
            
            if model.hasUnreadMessages {
                messageLabel.font = .boldSystemFont(ofSize: 14)
            } else {
                messageLabel.font = .systemFont(ofSize: 14)
            }
            
            messageLabel.text = model.message
            
            dateLabel.text = formDate(model.date)
        }
        
        if model.isOnline {
            backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 1.00)
        } else {
            backgroundColor = UIColor.clear
        }
    }
    
    private func formDate(_ date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date){
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
}
