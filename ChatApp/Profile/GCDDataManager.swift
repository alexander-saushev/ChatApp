//
//  GCDDataManager.swift
//  ChatApp
//
//  Created by Александр Саушев on 13.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit


class GCDDataManager: GetAndSaveProfileProtocol {
    
    let fileDirectory: URL
    let archiveURL: URL

    init() {
        fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = fileDirectory.appendingPathComponent("profile").appendingPathExtension("plist")
    }
    
    func getProfile(completion: @escaping (UserProfile) -> ()) {
        
        DispatchQueue.global(qos: .utility).async {
            let name = UserDefaults.standard.string(forKey: "user_name") ?? "Name"
            let description = UserDefaults.standard.string(forKey: "user_description") ?? "Description"
            let image: UIImage
            
            if let imageData = try? Data(contentsOf: self.archiveURL), UIImage(data: imageData) != nil {
                image = UIImage(data: imageData)!
            } else {
                image = UIImage(named: "avatarPlaceholder")!
            }
            
            var profile = UserProfile()
            profile.name = name
            profile.description = description
            profile.photo = image
            
            DispatchQueue.main.async {
                completion(profile)
            }
        }
        
    }
    
    func saveProfile(profile: UserProfile, completion: @escaping (Error?) -> ()) {
        
        DispatchQueue.global(qos: .utility).async {
            sleep(1)
            
            if profile.nameWasChanged {
                UserDefaults.standard.set(profile.name, forKey: "user_name")
            }
            
            if profile.descriptionWasChanged {
                UserDefaults.standard.set(profile.description, forKey: "user_description")
            }
            
            if profile.photoWasChanged {
                do {
                    try self.saveImage(profile.photo ?? UIImage(named: "avatarPlaceholder")!)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    

    
    func saveImage(_ image: UIImage) throws {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { throw
            DataImageError.dataError
        }
        do {
            try imageData.write(to: archiveURL, options: .noFileProtection)
        } catch let error {
            throw error
        }
    }
}


enum DataImageError: Error {
    case dataError
}
