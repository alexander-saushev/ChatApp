//
//  UserProfile.swift
//  ChatApp
//
//  Created by Александр Саушев on 13.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

struct UserProfile {
    var name: String = ""
    var description: String = ""
    var photo: UIImage?
    
    var nameWasChanged: Bool = false
    var descriptionWasChanged: Bool = false
    var photoWasChanged: Bool = false
    var dataWasChanged: Bool = false
}
