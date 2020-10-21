//
//  ChannelsService.swift
//  ChatApp
//
//  Created by Александр Саушев on 19.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import Firebase

final class ChannelsService {
    
    private var db = Firestore.firestore()
    
    private var channelsListener: ListenerRegistration?
    
    private lazy var channels: CollectionReference = {
        return db.collection("channels")
    }()
    
    deinit {
        channelsListener?.remove()
    }
    
    func subscribeOnChannels(handler: @escaping (Result<[Channel], Error>) -> Void) {
        channelsListener = channels.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(.failure(error))
            } else if let documents = querySnapshot?.documents {
                let channels = documents
                    .compactMap { Channel(identifier: $0.documentID,
                                          firestoreData: $0.data()) }
                handler(.success(channels))
            } else {
                handler(.failure(FirebaseError.snapshotIsNil))
            }
        }
    }
    
    func createChannel(name: String, handler: @escaping (Result<String, Error>) -> Void) {
        var ref: DocumentReference?
        ref = channels.addDocument(data: ["name": name]) { (error) in
            if let error = error {
                handler(.failure(error))
            } else if let channelId = ref?.documentID {
                handler(.success(channelId))
            } else {
                handler(.failure(FirebaseError.referenceIsNil))
            }
        }
    }
}

enum FirebaseError: Error {
    case snapshotIsNil
    case referenceIsNil
}
