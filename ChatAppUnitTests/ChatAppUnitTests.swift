//
//  ChatAppUnitTests.swift
//  ChatAppUnitTests
//
//  Created by Александр Саушев on 03.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

@testable import ChatApp
import XCTest

class LoaderImagesServiceTests: XCTestCase {
  
  func testRequestConfig() throws {
    // Arrange
    let testHits = [Hit(previewURL: ""),
                Hit(previewURL: ""),
                Hit(previewURL: ""),
                Hit(previewURL: ""),
                Hit(previewURL: "")
    ]
    
    var returnedTestHits = [Hit]()
    let empty = Empty(totalHits: testHits.count, hits: testHits)
    let url = URL(string: "https://pixabay.com/api/?q=green+apples&image_type=photo&per_page=50&key=19168219-250301f0b178fcfe3f1b565a2")!
    
    let networkDataFetcherMock = MockNetworkDataFetcher()
    networkDataFetcherMock.loadDataStub = { completion in
      completion(.success(empty))
    }
    // Act
    let loaderImagesService = LoaderImagesService(networkDataFetcher: networkDataFetcherMock)
    
    loaderImagesService.loadImages { result in
      switch result {
      case .success(let hits):
        returnedTestHits.append(contentsOf: hits)
      case .failure(_):
        break
      }
    }
    
    // Asserts
    XCTAssertEqual(returnedTestHits, testHits)
    XCTAssertEqual(networkDataFetcherMock.callsCount, 1)
    XCTAssertEqual(networkDataFetcherMock.urlRequest.url, url)
    XCTAssertEqual(networkDataFetcherMock.urlRequest.httpMethod, "GET")
  }
  
    func testInvalidRequest() throws {
  
      // Arrange
      let error: NetworkingError = .invalideRequest
      var returnedError: NetworkingError?
      let networkDataFetcherMock = MockNetworkDataFetcher()
      networkDataFetcherMock.loadDataStub = { completion in
        completion(.failure(error))
      }
  
      //Act
      let loaderImagesService = LoaderImagesService(networkDataFetcher: networkDataFetcherMock)
  
      loaderImagesService.loadImages { result in
        switch result {
        case .success(_): break
        case .failure(let error):
          returnedError = error
        }
      }
  
      // Asserts
      XCTAssertEqual(returnedError, error)
    }
  
  func testInternetConnectionFailed() throws {
    
    // Arrange
    let error: NetworkingError = .internetConnectionFail
    var returnedError: NetworkingError?
    
    let networkDataFetcherMock = MockNetworkDataFetcher()
    networkDataFetcherMock.loadDataStub = { completion in
      completion(.failure(error))
    }
    
    //Act
    let loaderImagesService = LoaderImagesService(networkDataFetcher: networkDataFetcherMock)

    loaderImagesService.loadImages { result in
      switch result {
      case .success(_): break
      case .failure(let error):
       returnedError = error
      }
    }
    
    // Asserts
    XCTAssertEqual(returnedError, error)
    
  }
}
