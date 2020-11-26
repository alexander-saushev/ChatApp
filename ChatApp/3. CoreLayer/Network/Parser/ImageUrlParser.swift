//
//  ImageUrlParser.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct ImagePickerJSON: Codable {
    let hits: [Images]
}

struct Images: Codable {
    let webformatURL: String
    let previewURL: String
}

class ImageURLParser: IParser {
    typealias Model = [Images]

    func parse(data: Data) -> [Images]? {
        do {
            let images = try JSONDecoder().decode(ImagePickerJSON.self, from: data).hits
            return images
        } catch {
            print(error)
            return nil
        }
    }
}
