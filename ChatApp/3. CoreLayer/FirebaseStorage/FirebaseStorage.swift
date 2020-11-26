//
//  FirebaseStorage.swift
//  ChatApp
//
//  Created by Александр Саушев on 11.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import Firebase

struct ChannelFB {
  let documentId: String
  let name: String
  let lastMessage: String
  let lastActivity: Timestamp
}

struct MessageFB {
  let senderId: String
  let senderName: String
  let content: String
  let created: Timestamp
}

protocol IFirebaseStorage {
  func insertChannel(newChannel: [String: Any])
  func deleteChannel(identifier: String, completion: @escaping () -> Void)
  func fetchChannel(completion: @escaping (ChannelFB) -> Void, saveCompletion: @escaping () -> Void)

  func insertMessage(channelId: String, newMessage: [String: Any])
  func fetchMessage(identifier: String, completion: @escaping (MessageFB) -> Void, saveCompletion: @escaping () -> Void)
}

class FirebaseStorage: IFirebaseStorage {

  private let database = Firestore.firestore()

  private lazy var referanceChannels = database.collection("channels")

  func insertChannel(newChannel: [String: Any]) {
    referanceChannels.addDocument(data: newChannel)
  }

  func deleteChannel(identifier: String, completion: @escaping () -> Void) {
    referanceChannels.document(identifier).delete(completion: { err in
      guard err == nil else {
        print("Error removing document: \(String(describing: err))")
        return }
      completion()
      print("FB: Success deleted!")
    })
  }

  func fetchChannel(completion: @escaping (ChannelFB) -> Void,
                    saveCompletion: @escaping () -> Void) {

    referanceChannels.addSnapshotListener { snapshot, _ in
      _ = snapshot?.documents.compactMap {
        guard let name         = $0["name"] as? String,
              let lastActivity = $0["lastActivity"] as? Timestamp,
              let lastMessage  = $0["lastMessage"] as? String
        else { return }
        completion(ChannelFB(documentId: $0.documentID,
                              name: name,
                              lastMessage: lastMessage,
                              lastActivity: lastActivity))
      }
      saveCompletion()
    }
  }

  func insertMessage(channelId: String, newMessage: [String: Any]) {
    referanceChannels.document(channelId).collection("messages").addDocument(data: newMessage)
  }

  func fetchMessage(identifier: String, completion: @escaping (MessageFB) -> Void,
                    saveCompletion: @escaping () -> Void) {
    referanceChannels.document(identifier).collection("messages").addSnapshotListener { (snapshot, _) in
      _ = snapshot?.documents.compactMap {
        guard
          let senderId = $0["senderId"] as? String,
          let senderName = $0["senderName"] as? String,
          let content = $0["content"] as? String,
          let created = $0["created"] as? Timestamp
        else { return }
        completion(MessageFB(senderId: senderId,
                              senderName: senderName,
                              content: content,
                              created: created))
      }
      saveCompletion()
    }
  }
}
