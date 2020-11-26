//
//  RequestFactory.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

struct RequestsFactory {
    struct Requests {
        static func newImageURLConfig() -> RequestConfig<ImageURLParser> {
            return RequestConfig<ImageURLParser>(request: ImageURLRequest(), parser: ImageURLParser())
        }
        
        static func newImageConfig(imageUrl: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(url: imageUrl)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
