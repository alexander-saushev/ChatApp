//
//  ImageCacheService.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

protocol IImageCacheService {
    func checkCache(url: String) -> UIImage?
    func saveToCache(url: String, image: UIImage)
}

class ImageCacheService: IImageCacheService {
    private var imageCache = NSCache<NSString, UIImage>()

    func checkCache(url: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            return cachedImage
        }
        return nil
    }

    func saveToCache(url: String, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }
}
