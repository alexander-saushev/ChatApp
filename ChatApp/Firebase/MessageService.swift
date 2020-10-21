//
//  MessageService.swift
//  ChatApp
//
//  Created by Александр Саушев on 19.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import Firebase

final class MessageService {
    
    private let channel: Channel
    
    private let db = Firestore.firestore()
    
    private lazy var messagesReference = {
        db.collection("channels/\(channel.identifier)/messages")
    }()
    
    private var messagesListener: ListenerRegistration?
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    deinit {
        messagesListener?.remove()
    }
    
    func subscribeOnMessages(handler: @escaping(Result<[Message], Error>) -> Void) {
        messagesListener = messagesReference.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(.failure(error))
            } else if let documents = querySnapshot?.documents {
                    let messages = documents
                        .compactMap { Message(firestoreData: $0.data()) }
                        .sorted(by: { $0.created < $1.created })
                    handler(.success(messages))
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
    
    func addMessage(content: String, handler: @escaping(Result<String, Error>) -> Void) {
        var ref: DocumentReference?
        ref = messagesReference.addDocument(
            data: [
                "content": content,
                "senderId": UserData.shared.identifier,
                "senderName": UserData.shared.name,
                "created": Timestamp(date: Date())
            ]) { (error) in
            if let error = error {
                handler(.failure(error))
            } else if let documentId = ref?.documentID {
                handler(.success(documentId))
            } else {
                handler(.failure(FirebaseError.referenceIsNil))
            }
        }
    }
    
}
