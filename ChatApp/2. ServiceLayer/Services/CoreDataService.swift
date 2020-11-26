//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Александр Саушев on 27.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataService {
  func setupChannelsFetchedResultsController() -> NSFetchedResultsController<Channel_db>
  func setupMessagesFetchedResultsController(channel: Channel_db) -> NSFetchedResultsController<Message_db>
    
  func saveChannels(_ channels: [ChannelCellDisplayModel])
  func deleteChannel(_ channelObject: NSManagedObject)

  func saveMessages(_ channel: Channel_db, _ messages: [MessageCellDisplay])
}

class CoreDataService: ICoreDataService {
    
    let coreDataStorage: ICoreDataStorage
    
    init(coreDataStorage: ICoreDataStorage) {
      self.coreDataStorage = coreDataStorage
    }
    
    func setupChannelsFetchedResultsController() -> NSFetchedResultsController<Channel_db> {
      let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
      let sortDescriptor = NSSortDescriptor(keyPath: \Channel_db.lastActivity, ascending: false)
      request.sortDescriptors = [sortDescriptor]
      let frc = NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: coreDataStorage.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      return frc
    }
    
    func setupMessagesFetchedResultsController(channel: Channel_db) -> NSFetchedResultsController<Message_db> {
      let request: NSFetchRequest<Message_db> = Message_db.fetchRequest()
      request.predicate = NSPredicate(format: "channel == %@", channel)
      let sortDescriptor = NSSortDescriptor(keyPath: \Message_db.created, ascending: true)
      request.sortDescriptors = [sortDescriptor]
      let frc = NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: coreDataStorage.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      return frc
    }
  
    func saveChannels(_ channels: [ChannelCellDisplayModel]) {
    
        coreDataStorage.performSave { context in
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let savedChannels = try? coreDataStorage.mainContext.fetch(request)
        channels.forEach { channel in
            
            let savedChannel = savedChannels?.filter {
                $0.identifier == channel.identifier
            }.first
            
            if savedChannel == nil {
                _ = Channel_db(identifier: channel.identifier,
                           name: channel.name,
                           lastActivity: channel.lastActivity,
                           lastMessage: channel.lastMessage,
                           in: context)
            } else {
                savedChannel?.name = channel.name
                savedChannel?.lastActivity = channel.lastActivity
                savedChannel?.lastMessage = channel.lastMessage
            }
        }
    }
  }
    
    func deleteChannel(_ channelObject: NSManagedObject) {

      coreDataStorage.mainContext.delete(channelObject)
      coreDataStorage.performSave(in: coreDataStorage.mainContext)
    }
  
    func saveMessages(_ channel: Channel_db, _ messages: [MessageCellDisplay]) {
    
    coreDataStorage.performSave { context in

      let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
      guard let identifier = channel.identifier else { return }
      request.predicate = NSPredicate(format: "identifier = %@", identifier)
      let objects = try? context.fetch(request)
      guard let channel = objects?.first
      else { return }
      
      var messagesDb = [Message_db]()
        messages.forEach { message in

          let savedMessage = channel.messages?.filter {
            message.created == ($0 as? Message_db)?.created
          }.first
          if savedMessage == nil {
            let messageDb = Message_db(senderId: message.senderId,
                                       senderName: message.senderName,
                                       content: message.content,
                                       created: message.created,
                                       in: context)
            messagesDb.append(messageDb)
            channel.addToMessages(messageDb)
          }
      }
      print("For channel:", channel.name!, "saved:", messagesDb.count, "messages")
    }
  }
}
