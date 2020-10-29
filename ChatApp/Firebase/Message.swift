//
//  Message.swift
//  ChatApp
//
//  Created by Александр Саушев on 19.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let senderId: String
    let senderName: String
    let content: String
    let created: Date
}
