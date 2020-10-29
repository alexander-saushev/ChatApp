//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Александр Саушев on 27.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
  
  static let shared = CoreDataManager()
  private init() {}
  
  let coreDataStack = CoreDataStack.shared
  
  func makeSaveChannelsRequest(channels: [Channel]) {
    var channelsDb = [Channel_db]()
    coreDataStack.performSave { context in
      channels.forEach {
        channelsDb.append(Channel_db(identifier: $0.identifier,
                                   name: $0.name,
                                   lastActivity: $0.lastActivity,
                                   lastMessage: $0.lastMessage,
                                   in: context))
      }
    }
  }
  
  func makeSaveMessagesRequest(channel: Channel, messages: [Message]) {
    
    coreDataStack.performSave { context in

      let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
      request.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
      let objects = try? context.fetch(request)
      guard let channel = objects?.first
      else { return }
      
      var messagesDb = [Message_db]()
      messages.forEach {
        let messageDb = Message_db(senderId: $0.senderId,
                                   senderName: $0.senderName,
                                   content: $0.content,
                                   created: $0.created,
                                   in: context)
        messagesDb.append(messageDb)
        channel.addToMessages(messageDb)
      
      }
      print("For channel:", channel.name!, "saved:", messagesDb.count, "messages")
    }
  }
}

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
