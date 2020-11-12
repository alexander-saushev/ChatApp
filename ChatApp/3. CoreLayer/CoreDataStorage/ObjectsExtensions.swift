//
//  ObjectsExtensions.swift
//  ChatApp
//
//  Created by Александр Саушев on 10.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
  convenience init(identifier: String,
                   name: String,
                   lastActivity: Date?,
                   lastMessage: String?,
                   in context: NSManagedObjectContext) {
    self.init(context: context)
    self.identifier = identifier
    self.name = name
    self.lastActivity = lastActivity
    self.lastMessage = lastMessage
  }
}

extension Message_db {
  convenience init(senderId: String,
                   senderName: String,
                   content: String,
                   created: Date,
                   in context: NSManagedObjectContext) {
    self.init(context: context)
    self.senderId = senderId
    self.senderName = senderName
    self.content = content
    self.created = created
  }
}
