//
//  MockNetworkDataFetcher.swift
//  ChatAppUnitTests
//
//  Created by Александр Саушев on 03.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

@testable import ChatApp
import Foundation

final class MockNetworkDataFetcher: INetworkDataFetcher {
  
  var callsCount = 0
  var urlRequest: URLRequest!
  
  var loadDataStub: (((Result<JsonParser.Model, NetworkingError>) -> Void) -> Void)!
  
  func fetchData(from config: RequestConfig<JsonParser>, completion: @escaping (Result<JsonParser.Model, NetworkingError>) -> Void) {
    callsCount += 1
    urlRequest = config.request.urlRequest!
    loadDataStub(completion)
  }
}
