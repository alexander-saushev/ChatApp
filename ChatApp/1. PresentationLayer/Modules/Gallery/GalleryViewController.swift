//
//  GalleryViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 30.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
  func updateProfile(_ galleryViewController: GalleryViewController, urlImageData: Data)
}

class GalleryViewController: UIViewController {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var galleryCollectionView: UICollectionView!
  @IBAction func closeButtonAction(_ sender: Any) {
    self.dismiss(animated: true)
  }
    
  private var model: IGalleryModel!
    
  private let cellId = String(describing: ImageCollectionViewCell.self)
  
  weak var delegate: GalleryViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model.delegate = self
    model.fetchGallery()
    activityIndicator.startAnimating()
    activityIndicator.hidesWhenStopped = true
  }
  
  func setupDepenencies(model: IGalleryModel, presentationAssembly: IPresentationAssembly?) {
    self.model = model
  }
  
}

extension GalleryViewController: IGalleryModelDelegate {
  func onFetchCompleted(_ galleryModel: GalleryModel) {
    activityIndicator.stopAnimating()
    galleryCollectionView.reloadData()
  }
  
  func onFetchFailed(error: Error) {
    activityIndicator.stopAnimating()
    galleryCollectionView.reloadData()
  }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.currentCount
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ImageCollectionViewCell else {
        return UICollectionViewCell()
    }
    
    if model.galleryOfImages.isEmpty {
      cell.configure(galleryDisplayModel: nil)
    } else {
      let displayModel = model.galleryOfImages[indexPath.item]
      cell.configure(galleryDisplayModel: displayModel)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item)
    let urlImage = model.galleryOfImages[indexPath.item].urlImageData

    delegate?.updateProfile(self, urlImageData: urlImage)
    
    self.dismiss(animated: true)
    
  }
}
