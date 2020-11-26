//
//  RequestProtocol.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

protocol IRequest {
    func urlRequest(pageNumber: Int?) -> URLRequest?
}
