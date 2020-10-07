//
//  DayTheme.swift
//  ChatApp
//
//  Created by Александр Саушев on 05.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

final class DayTheme: ThemeModel {
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var navigationBarStyle: UIBarStyle = .default
    var incommingMessageBubbleColor: UIColor = UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1)
    var outgoingMessageBubbleColor: UIColor = UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
    var incommingMessageTextColor: UIColor = .black
    var outgoingMessageTextColor: UIColor = .white
    var conversationsListTextColor: UIColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 1.00)
    var saveButtonColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    var profileHeaderColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
    var sectionHeaderBackgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    var alertBackgroundColor: UIColor = .white
}
