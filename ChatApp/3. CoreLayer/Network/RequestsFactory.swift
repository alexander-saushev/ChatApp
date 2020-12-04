//
//  RequestsFactory.swift
//  ChatApp
//
//  Created by Александр Саушев on 30.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct RequestsFactory {
  
  struct PixbayAPIRequests {
    
    struct ImagesRequests {
      static func requestConfig() -> RequestConfig<JsonParser> {
        let request = PixbayAPIRequest()
          let sender = RequestSender()
          
          return RequestConfig<JsonParser>(request: request, sender: sender, parser: JsonParser())
        }
    }
  }
}
