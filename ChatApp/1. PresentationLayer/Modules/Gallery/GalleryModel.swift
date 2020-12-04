//
//  GalleryModel.swift
//  ChatApp
//
//  Created by Александр Саушев on 30.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation
import UIKit

// MARK: GalleryDisplayModel
struct GalleryDisplayModel {
  let urlImageData: Data
}

// MARK: IGalleryModel protocol
protocol IGalleryModel {
  var cellsCount: Int { get }
  var currentCount: Int { get }
  var galleryOfImages: [GalleryDisplayModel] { get set }
  var delegate: IGalleryModelDelegate? { get set }
  
  func fetchGallery()
}

// MARK: IGalleryModelDelegate protocol
protocol IGalleryModelDelegate: class {
  func onFetchCompleted(_ galleryModel: GalleryModel)
  func onFetchFailed(error: Error)
}

class GalleryModel: IGalleryModel {
  
  // MARK: Public properties
  var galleryOfImages = [GalleryDisplayModel]()
  let loaderImagesService: ILoaderImagesService
  weak var delegate: IGalleryModelDelegate?
  
  var currentCount: Int {
    galleryOfImages.count
  }
  
  var cellsCount: Int {
    50
  }
  
  // MARK: Initializers
  init(loaderImagesService: ILoaderImagesService) {
    self.loaderImagesService = loaderImagesService
  }
  
  // MARK: Public Methods
  func fetchGallery() {
    loaderImagesService.loadImages { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.galleryOfImages.append(contentsOf: response.getGallery())
        DispatchQueue.main.async {
          self.delegate?.onFetchCompleted(self)
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          self.delegate?.onFetchFailed(error: error)
        }
      }
    }
  }
}

// MARK: Extension Array
extension Array where Element == Hit {
  func getGallery() -> [GalleryDisplayModel] {
    var data = Data()
    return self.map { hit -> GalleryDisplayModel in
      if let resource = URL(string: hit.previewURL) {
        do {
          data = try Data(contentsOf: resource)
        } catch {}
      }
      return GalleryDisplayModel(urlImageData: data)
    }
  }
}
