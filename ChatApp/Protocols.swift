//
//  Protocols.swift
//  ChatApp
//
//  Created by Александр Саушев on 03.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
