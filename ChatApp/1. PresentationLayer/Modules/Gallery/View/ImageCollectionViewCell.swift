//
//  ImageCollectionViewCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 03.12.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func configure(galleryDisplayModel: GalleryDisplayModel?) {

    guard let galleryDisplayModel = galleryDisplayModel
    else {
      setupPlaceholder()
      return
    }
    self.imageView.image = UIImage(data: galleryDisplayModel.urlImageData)
    deletePlaceholder()
    
  }
  
  private func setupPlaceholder() {
    imageView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    imageView.contentMode = .center
    imageView.image = UIImage(named: "avatarPlaceholder")
  }
  
  private func deletePlaceholder() {
    imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    imageView.contentMode = .scaleAspectFill
    
  }
}
