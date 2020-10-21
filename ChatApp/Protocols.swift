//
//  Protocols.swift
//  ChatApp
//
//  Created by Александр Саушев on 03.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

protocol ThemesPickerDelegate: class {
    func setTheme(_ theme: ThemeModel)
}

protocol GetAndSaveProfileProtocol {
    func getProfile(completion: @escaping (UserProfile) -> Void)
    func saveProfile(profile: UserProfile, completion: @escaping(Error?) -> Void)
}
