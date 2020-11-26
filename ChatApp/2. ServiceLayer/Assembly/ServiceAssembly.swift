//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Александр Саушев on 10.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
  var coreDataService: ICoreDataService { get }
  var operationSaveService: IProfileService { get }
  var gcdSaveService: IProfileService { get }
  var firebaseService: IFirebaseService { get }
  var networkService: INetworkService { get }
  var imageCacheService: IImageCacheService { get }
}

class ServiceAssembly: IServiceAssembly {
  private let coreAssembly: ICoreAssembly
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }

  lazy var coreDataService: ICoreDataService = CoreDataService(coreDataStorage: self.coreAssembly.coreDataStorage)
  lazy var operationSaveService: IProfileService = OperationSaveService(profileStorage: self.coreAssembly.profileStorage)
  lazy var gcdSaveService: IProfileService = GCDSaveService(profileStorage: self.coreAssembly.profileStorage)
  lazy var firebaseService: IFirebaseService = FirebaseService(firebaseStorage: self.coreAssembly.firebaseStorage)
  lazy var networkService: INetworkService = NetworkService(requestSender: coreAssembly.requestSender)
  lazy var imageCacheService: IImageCacheService = ImageCacheService()
}
