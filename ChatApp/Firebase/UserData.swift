//
//  UserData.swift
//  ChatApp
//
//  Created by Александр Саушев on 19.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

class UserData {
    
    static var shared: UserData = UserData()
    private init() { }
    private static var keyIdentifier = "user_identifier"
    private var _identifier: String?
    
    var identifier: String {
        if let id = _identifier {
            return id
        } else if let id = UserDefaults.standard.string(forKey: Self.keyIdentifier) {
            _identifier = id
            return id
        } else {
            let id = UUID().uuidString
            UserDefaults.standard.setValue(id, forKey: Self.keyIdentifier)
            _identifier = id
            return id
        }
    }
    
    var name: String {
        return "Sasha Saushev"
    }
}
