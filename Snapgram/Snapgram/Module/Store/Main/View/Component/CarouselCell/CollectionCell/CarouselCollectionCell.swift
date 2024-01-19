//
//  CarouselCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import Kingfisher

class CarouselCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var carouselImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.makeCornerRadius(16.0)
    }
    
    internal func configure(with carousel: GalleryModel) {
        let url = URL(string: carousel.url)
        carouselImg.kf.setImage(with: url, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
