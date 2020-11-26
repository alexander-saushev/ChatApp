//
//  ClassicTheme.swift
//  ChatApp
//
//  Created by Александр Саушев on 05.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

final class ClassicTheme: ThemeModel {
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var navigationBarStyle: UIBarStyle = .default
    var incommingMessageBubbleColor: UIColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    var outgoingMessageBubbleColor: UIColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    var incommingMessageTextColor: UIColor = .black
    var outgoingMessageTextColor: UIColor = .black
    var conversationsListTextColor: UIColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1.00)
    var saveButtonColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    var profileHeaderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    var sectionHeaderBackgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    var alertBackgroundColor: UIColor = .white
    
}
