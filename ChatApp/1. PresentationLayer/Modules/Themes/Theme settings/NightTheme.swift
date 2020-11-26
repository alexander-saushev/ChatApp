//
//  NightTheme.swift
//  ChatApp
//
//  Created by Александр Саушев on 05.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

final class NightTheme: ThemeModel {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var navigationBarStyle: UIBarStyle = .black
    var incommingMessageBubbleColor: UIColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    var outgoingMessageBubbleColor: UIColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    var incommingMessageTextColor: UIColor = .white
    var outgoingMessageTextColor: UIColor = .white
    var conversationsListTextColor: UIColor = UIColor(red: 0.55, green: 0.55, blue: 0.58, alpha: 1.00)
    var saveButtonColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
    var profileHeaderColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.00)
    var sectionHeaderBackgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)
    var alertBackgroundColor: UIColor = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1.00)
}
