//
//  CoreDataStorage.swift
//  ChatApp
//
//  Created by Александр Саушев on 27.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import CoreData
import os.log

protocol ICoreDataStorage {
  var mainContext: NSManagedObjectContext { get }
  func performSave(_ block: (NSManagedObjectContext) -> Void)
  func performSave(in context: NSManagedObjectContext)
}

final class CoreDataStorage: ICoreDataStorage {
  
  var didUpdateDataBase: ((CoreDataStorage) -> Void)?
    
  private var storeUrl: URL = {
    guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask).last
    else { fatalError("document path not found") }
    
    return documentsUrl.appendingPathComponent("Chat.sqlite")
  }()
  
  private let dataModelName = "Chat"
  private let dataModelExtension = "momd"

  private(set) lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                         withExtension: self.dataModelExtension)
    else { fatalError("model not found") }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
    else { fatalError("managedObjectModel could't be created") }
    return managedObjectModel
  }()

  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                         configurationName: nil,
                                         at: self.storeUrl,
                                         options: nil)
    } catch {
      fatalError(error.localizedDescription)
    }
    return coordinator
  }()
  
    lazy var masterContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.persistentStoreCoordinator = persistentStoreCoordinator
    context.mergePolicy = NSOverwriteMergePolicy
    return context
  }()
  
  private(set) lazy var mainContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = masterContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return context
  }()
  
  private func saveContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = mainContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return context
  }
  
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }

    func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
             try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
  
  func enableObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(managedObjectContextObjectsChange(notification:)),
                                   name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                   object: mainContext)
  }
  
  @objc private func managedObjectContextObjectsChange(notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return }
    
    didUpdateDataBase?(self)
    
      if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
         inserts.count > 0 {
        print("Add objects: ", inserts.count)
      }
      if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
         updates.count > 0 {
        print("Update objects: ", updates.count)
      }
      if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
         deletes.count > 0 {
        print("Delete objects: ", deletes.count)
      }
  }
  
  func printDatabaseStatistics() {
      mainContext.perform {
        do {
          let countChannels = try self.mainContext.count(for: Channel_db.fetchRequest())
          print("Saved channels: ", countChannels)
          let countMessages = try self.mainContext.count(for: Message_db.fetchRequest())
          print("Saved messages: ", countMessages)

        } catch {
          fatalError(error.localizedDescription)
        }
      }
  }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let coreData = OSLog(subsystem: subsystem, category: "coreData")
}
