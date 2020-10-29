//
//  OutgoingMessageCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet weak var outgoingBubbleView: UIView!
    @IBOutlet weak var outgoingMessageLabel: UILabel!
    @IBOutlet weak var outgoingMessageLeadingConstraint: NSLayoutConstraint!
}

extension OutgoingMessageCell: ConfigurableView {
    
    func configure(with model: Message) {
        
        outgoingBubbleView?.layer.cornerRadius = 10
        outgoingMessageLabel?.text = model.content
        outgoingBubbleView?.backgroundColor = Theme.current.outgoingMessageBubbleColor
        outgoingMessageLabel?.textColor = Theme.current.outgoingMessageTextColor
        outgoingMessageLeadingConstraint?.isActive = false
        }
    }
