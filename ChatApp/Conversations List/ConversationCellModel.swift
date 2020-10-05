//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Александр Саушев on 04.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
