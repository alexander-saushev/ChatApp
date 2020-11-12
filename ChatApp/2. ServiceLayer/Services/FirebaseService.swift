//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Александр Саушев on 25.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import Firebase

protocol IFirebaseService {
  var senderId: String? { get set }
  
  func insertChannel(name: String)
  func deleteChannel(_ channel: Channel_db, completion: @escaping () -> Void)
  func getChannels(completion: @escaping ([ChannelCellDisplayModel]) -> Void)
  
  func insertMessage(channelId: String, message: String)
  func getMessages(channel: Channel_db, completion: @escaping ([MessageCellDisplay]) -> Void)
}

final class FirebaseService: IFirebaseService {
  
  var senderId = UIDevice.current.identifierForVendor?.uuidString
  let firebaseStorage: IFirebaseStorage
  
  init(firebaseStorage: IFirebaseStorage) {
    self.firebaseStorage = firebaseStorage
  }
  
  func insertChannel(name: String) {
    let newChannel: [String: Any] = ["name": name,
                                      "lastActivity": Date(),
                                      "lastMessage": "No messages yet"]
    firebaseStorage.insertChannel(newChannel: newChannel)
  }
    
    func deleteChannel(_ channel: Channel_db, completion: @escaping () -> Void) {
      guard let identifier = channel.identifier else { return }
      firebaseStorage.deleteChannel(identifier: identifier, completion: completion)
    }
  
    func getChannels(completion: @escaping ([ChannelCellDisplayModel]) -> Void) {
      var channels = [ChannelCellDisplayModel]()
    
        firebaseStorage.fetchChannel {
          let channel = ChannelCellDisplayModel(identifier: $0.documentId,
                                                name: $0.name,
                                                lastMessage: $0.lastMessage,
                                                lastActivity: Date(timeIntervalSince1970: TimeInterval($0.lastActivity.seconds)))
          channels.append(channel)
        } saveCompletion: {
          completion(channels)
    }
  }
  
  func insertMessage(channelId: String, message: String) {
    guard let senderId = self.senderId else { return }
    let newMessage: [String: Any] = ["content": message,
                                     "created": Date(),
                                     "senderName": "S",
                                     "senderId": senderId]
    firebaseStorage.insertMessage(channelId: channelId, newMessage: newMessage)
  }
  
    func getMessages(channel: Channel_db, completion: @escaping ([MessageCellDisplay]) -> Void) {
      var messages = [MessageCellDisplay]()
      guard let identifier = channel.identifier else { return }
      firebaseStorage.fetchMessage(identifier: identifier) {
      let message = MessageCellDisplay(senderId: $0.senderId,
                                           senderName: $0.senderName,
                                           content: $0.content,
                                           created: Date(timeIntervalSince1970: TimeInterval($0.created.seconds)))
          messages.append(message)
        } saveCompletion: {
          completion(messages)
    }
  }
}
