//
//  RequestSender.swift
//  ChatApp
//
//  Created by Александр Саушев on 03.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
  let request: IPixbayAPIRequest
  let sender: IRequestSender
  let parser: Parser
}

protocol IRequestSender {
  func send<Parser>(request config: RequestConfig<Parser>, completion: @escaping (Result<Data, NetworkingError>) -> Void)
}

class RequestSender: IRequestSender {

  let session = URLSession.shared
    
  func send<Parser>(request config: RequestConfig<Parser>, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
    guard let urlRequest = config.request.urlRequest else {
      completion(.failure(.invalideRequest))
      return
    }
    
    let task = session.dataTask(with: urlRequest) { (data: Data?, _, error: Error?) in
      if error != nil {
        completion(.failure(.internetConnectionFail))
        return
      }
      guard let data = data else {
        completion(.failure(.decodingError))
        return
      }
      completion(Result.success(data))
    }
    task.resume()
  }
}

enum NetworkingError: String, Error {
  case invalideRequest = "error.invalideRequest"
  case failDataTaskURL = "error.failDataTask"
  case internetConnectionFail = "error.notConnectedToInternet"
  case cannotFindHost = "error.errorCannotFindHost"
  case decodingError = "The given data was not valid JSON"
  case timeOut = "error.timeOut"
  case apiKeyInvalid = "Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key."
  case notFound = "Not found resourse"
  case unknownError = "Unknown error"
}

extension NetworkingError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "")}
}
