//
//  IncommingMessageCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class IncommingMessageCell: UITableViewCell {
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var senderNameLabel: UILabel!
}

extension IncommingMessageCell: ConfigurableView {
    
    func configure(with model: Message) {
        
        bubbleView?.layer.cornerRadius = 10
        messageLabel?.text = model.content
        senderNameLabel?.text = model.senderName
        bubbleView?.backgroundColor = Theme.current.incommingMessageBubbleColor
        messageLabel?.textColor = Theme.current.incommingMessageTextColor
        trailingConstraint?.isActive = false
        leadingConstraint?.isActive = true
    }
}
