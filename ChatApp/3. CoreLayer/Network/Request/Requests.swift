//
//  Requests.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

class ImageURLRequest: IRequest {
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let pageNumber = pageNumber,
              let url = urlConstructor(pageNumber: pageNumber) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
    
    private func urlConstructor(pageNumber: Int) -> URL? {
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "pixabay.com"
        urlConstructor.path = "/api"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: "19168219-250301f0b178fcfe3f1b565a2"),
            URLQueryItem(name: "q", value: "green+apples"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        return urlConstructor.url
    }
}

class ImageRequest: IRequest {
    var url: String
    
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
    
    init(url: String) {
        self.url = url
    }
}
