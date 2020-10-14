//
//  OperationDataManager.swift
//  ChatApp
//
//  Created by Александр Саушев on 13.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import UIKit


class OperationDataManager: GetAndSaveProfileProtocol {
    
    let fileDirectory: URL
    let archiveURL: URL
    let operationQueue = OperationQueue()
    
    init() {
        fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = fileDirectory.appendingPathComponent("profile").appendingPathExtension("plist")
    }
    
    func getProfile(completion: @escaping (UserProfile) -> ()) {
        let getOperation = GetUserProfile()
        getOperation.archiveURL = archiveURL
        getOperation.completionHandler = completion
        operationQueue.addOperation(getOperation)
    }
    
    func saveProfile(profile: UserProfile, completion: @escaping (Error?) -> ()) {
        
        let saveOperation = SaveUserProfile(nameChanged: profile.nameWasChanged, descriptionChanged: profile.descriptionWasChanged, photoChanged: profile.photoWasChanged)
        saveOperation.userProfile = profile
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        operationQueue.addOperation(saveOperation)
        
    }
}


class GetUserProfile: Operation {
    
    var profile: UserProfile!
    var archiveURL: URL!
    var completionHandler: ((UserProfile) -> ())!
    
    override func main() {
        sleep(1)
        
        let name = UserDefaults.standard.string(forKey: "user_name") ?? "Name"
        let description = UserDefaults.standard.string(forKey: "user_description") ?? "Description"
        let photo: UIImage
        
        if let imageData = try? Data(contentsOf: archiveURL), UIImage(data: imageData) != nil {
            photo = UIImage(data: imageData)!
        } else {
            photo = UIImage(named: "avatarPlaceholder")!
        }
        
        profile = UserProfile()
        profile.name = name
        profile.description = description
        profile.photo = photo
        
        OperationQueue.main.addOperation {
            self.completionHandler(self.profile)
            
        }
    }
}

class SaveUserProfile: Operation {
    var userProfile: UserProfile!

    var completionHandler: ((Error?) -> ())!
    var archiveURL: URL!
    
    let nameChanged: Bool
    let descriptionChanged: Bool
    let photoChanged: Bool

    init(nameChanged: Bool, descriptionChanged: Bool, photoChanged: Bool) {
        self.nameChanged = nameChanged
        self.descriptionChanged = descriptionChanged
        self.photoChanged = photoChanged
    }
    
    override func main() {
        sleep(1)
        
        if nameChanged {
            UserDefaults.standard.set(userProfile.name, forKey: "user_name")
        }
        
        if descriptionChanged {
            UserDefaults.standard.set(userProfile.description, forKey: "user_description")
        }
        
        if photoChanged {
            guard let imageData = userProfile.photo?.jpegData(compressionQuality: 1.0) else {
                OperationQueue.main.addOperation {
                    self.completionHandler(DataImageError.dataError)
                }
                return
            }
            do {
                try imageData.write(to: archiveURL, options: .noFileProtection)
            } catch let error {
                self.completionHandler(error)
            }
        }
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }
}
