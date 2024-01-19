//
//  PostPhotoCell.swift
//  Snapgram
//
//  Created by Phincon on 05/12/23.
//

import UIKit
import Kingfisher

class PostPhotoCell: UICollectionViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollection(_ post: ListStory) {
        let url = URL(string: post.photoURL)
        let size = postImage.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        postImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }
}
