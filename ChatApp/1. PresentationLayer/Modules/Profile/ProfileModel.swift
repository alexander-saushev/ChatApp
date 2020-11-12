//
//  UserProfile.swift
//  ChatApp
//
//  Created by Александр Саушев on 13.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

struct Profile {

  var userName: String
  var userBio: String
  var userData: Data

  var nameChanged: Bool = false
  var bioChanged: Bool = false
  var photoChanged: Bool = false

}

protocol IProfileModel {
  func save(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
  func retriveProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

class ProfileModel: IProfileModel {
  let profileService: IProfileService

  init(profileService: IProfileService) {
    self.profileService = profileService
  }

  func save(profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
    profileService.save(profile: profile, completion: completion)
  }

  func retriveProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
    profileService.retrive(completion: completion)
  }

}
