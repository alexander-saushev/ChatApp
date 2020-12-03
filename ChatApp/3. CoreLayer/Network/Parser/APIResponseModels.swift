//
//  APIResponseModels.swift
//  ChatApp
//
//  Created by Александр Саушев on 04.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct Empty: Codable {
  let totalHits: Int
  let hits: [Hit]
}

// MARK: - Hit
public struct Hit: Codable, Equatable {
  let previewURL: String
}
