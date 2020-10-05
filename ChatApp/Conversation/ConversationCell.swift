//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = MessageCellModel
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    func configure(with model: ConfigurationModel) {
        
        bubbleView?.layer.cornerRadius = 10
        
        messageLabel?.text = model.text
        
        if model.isIncoming {
            bubbleView?.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.91, alpha: 1.00)
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
        } else {
            bubbleView?.backgroundColor = UIColor(red: 0.86, green: 0.97, blue: 0.77, alpha: 1.00)
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
        }
    }
    
}
