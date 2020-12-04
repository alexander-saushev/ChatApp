//
//  PixbayAPIRequest.swift
//  ChatApp
//
//  Created by Александр Саушев on 30.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct API {
  static let scheme = "https"
  static let host = "pixabay.com"
  static let path = "/api/"
  
  static let apiKey = "19168219-250301f0b178fcfe3f1b565a2"
  
  enum QueryItemName: String {
    case imageType = "image_type"
    case q = "q"
    case key = "key"
    case perPage = "per_page"
  }
}

protocol IPixbayAPIRequest {
  var urlRequest: URLRequest? { get }
}

class PixbayAPIRequest: IPixbayAPIRequest {
  
  var urlRequest: URLRequest? {
    let url = urlPath([URLQueryItem(name: API.QueryItemName.q.rawValue,
                                    value: "green+apples"),
                       URLQueryItem(name: API.QueryItemName.imageType.rawValue,
                                    value: "photo"),
                       URLQueryItem(name: API.QueryItemName.perPage.rawValue,
                                    value: "50")])
    guard let urlPath = url else { return nil }
    return URLRequest(url: urlPath)
    
  }
  
  private func urlPath( _ queryItems: [URLQueryItem]) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = API.scheme
    urlComponents.host = API.host
    urlComponents.path = API.path
    urlComponents.queryItems = queryItems + [URLQueryItem(name: API.QueryItemName.key.rawValue, value: API.apiKey)]
    
    return urlComponents.url
  }
}
