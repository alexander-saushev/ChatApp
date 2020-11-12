//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Александр Саушев on 10.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
  
  func entryPoint() -> UINavigationController
  func profileViewController() -> ProfileViewController
  func conversationViewController() -> ConversationViewController
}

class PresentationAssembly: IPresentationAssembly {
  
  let serviceAssembly: IServiceAssembly
  
  init(serviceAssembly: IServiceAssembly) {
    self.serviceAssembly = serviceAssembly
  }
  
  // MARK: - ConversationsListViewController
  func entryPoint() -> UINavigationController {
    let model = conversationsListModel()
    let storyboard = UIStoryboard(name: "ConversationsListViewController", bundle: nil)
    let rootController = storyboard.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController
    
    let conversationsListVC = rootController?.viewControllers.first as? ConversationsListViewController
    conversationsListVC?.model = model
    conversationsListVC?.presentationAssembly = self
    return rootController ?? UINavigationController()
  }
  
  private func conversationsListModel() -> IConversationsListModel {
    return ConversationsListModel(coreDataService: self.serviceAssembly.coreDataService,
                                  profileSaveService: self.serviceAssembly.gcdSaveService,
                                  firebaseService: self.serviceAssembly.firebaseService)
  }
  
  // MARK: - ConversationViewController
  func conversationViewController() -> ConversationViewController {
    let model = conversationModel()
    
    let conversationStoryboard = UIStoryboard(name: "ConversationViewController", bundle: nil)
    let conversationVC = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
    conversationVC?.model = model
    conversationVC?.presentationAssembly = self
    
    return conversationVC!
  }
  
  private func conversationModel() -> IConversationModel {
    return ConversationModel(coreDataService: self.serviceAssembly.coreDataService,
                             firebaseService: self.serviceAssembly.firebaseService)
  }
  
  // MARK: - ProfileViewController
  func profileViewController() -> ProfileViewController {
    
    let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
    let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
    
    switch profileVC?.savingType {
    case .gcd:
      let model = profileModel(savingType: .gcd)
      profileVC?.model = model
    case .operation:
      let model = profileModel(savingType: .operation)
      profileVC?.model = model
    case .none:
        print("")
    }
    profileVC?.operationModel = profileModel(savingType: .operation)
    profileVC?.presentationAssembly = self
    return profileVC!
  }
  
  private func profileModel(savingType: ProfileSavingType) -> IProfileModel {
    switch savingType {
    case .operation:
      return ProfileModel(profileService: self.serviceAssembly.operationSaveService)
    case .gcd:
      return ProfileModel(profileService: self.serviceAssembly.gcdSaveService)
    }
  }
}
