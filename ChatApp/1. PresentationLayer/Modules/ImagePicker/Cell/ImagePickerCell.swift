//
//  ImagePickerCellCollectionViewCell.swift
//  ChatApp
//
//  Created by Александр Саушев on 19.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var cellTag: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = UIImage(named: "imagePlaceholder")
    }

    func configure(image: UIImage?) {
        imageView?.image = image
    }
}
