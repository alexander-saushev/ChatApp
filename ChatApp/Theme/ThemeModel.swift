//
//  ThemeModel.swift
//  ChatApp
//
//  Created by Александр Саушев on 05.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

protocol ThemeModel {
    var backgroundColor: UIColor { get }
    var navigationBarStyle: UIBarStyle { get }
    var textColor: UIColor { get }
    var incommingMessageBubbleColor: UIColor { get }
    var outgoingMessageBubbleColor: UIColor { get }
    var incommingMessageTextColor: UIColor { get }
    var outgoingMessageTextColor: UIColor { get }
    var conversationsListTextColor: UIColor { get }
    var saveButtonColor: UIColor { get }
    var profileHeaderColor: UIColor { get }
    var sectionHeaderBackgroundColor: UIColor { get }
    var alertBackgroundColor: UIColor { get }
}
