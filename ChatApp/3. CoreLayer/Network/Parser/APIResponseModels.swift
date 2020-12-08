//
//  APIResponseModels.swift
//  ChatApp
//
//  Created by Александр Саушев on 30.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct Empty: Codable {
  let totalHits: Int
  let hits: [Hit]
}

public struct Hit: Codable, Equatable {
  let previewURL: String
}
