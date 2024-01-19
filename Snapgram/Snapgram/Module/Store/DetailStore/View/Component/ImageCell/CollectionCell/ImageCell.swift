//
//  ImageCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var detailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure(with carousel: GalleryModel) {
        let url = URL(string: carousel.url)
        detailImage.kf.setImage(with: url, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
