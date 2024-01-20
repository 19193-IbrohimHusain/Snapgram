//
//  DetailUserPostCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit
import Kingfisher

class UserPostCell: UICollectionViewCell {

    @IBOutlet weak var postImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure(with post: ListStory) {
        let url = URL(string: post.photoURL)
        let size = postImg.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        postImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
