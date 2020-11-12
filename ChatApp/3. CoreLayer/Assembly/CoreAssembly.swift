//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Александр Саушев on 10.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
protocol ICoreAssembly {
  var coreDataStorage: ICoreDataStorage { get }
  var profileStorage: IProfileStorage { get }
  var firebaseStorage: IFirebaseStorage { get }

}

class CoreAssembly: ICoreAssembly {
  lazy var profileStorage: IProfileStorage = ProfileStorage()
  lazy var coreDataStorage: ICoreDataStorage = CoreDataStorage()
  lazy var firebaseStorage: IFirebaseStorage = FirebaseStorage()

}
