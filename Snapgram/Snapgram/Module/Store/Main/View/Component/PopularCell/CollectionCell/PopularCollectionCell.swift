//
//  PopularCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import Kingfisher

class PopularCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    private func setupCollection() {
        bgView.addShadow()
        bgView.makeCornerRadius(16)
        bgView.layer.masksToBounds = false
        productImg.layer.cornerRadius = 16
        productImg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    internal func configure(with product: ProductModel) {
        configureImage(product)
        productCategory.text = product.category.name
        productName.text = product.name
        productPrice.text = "$ \(product.price)"
    }
    
    private func configureImage(_ product: ProductModel) {
        if let gallery = product.galleries?.dropFirst(3).first {
            let url = URL(string: gallery.url)
            let size = productImg.bounds.size
            let processor = DownsamplingImageProcessor(size: size)
            productImg.kf.setImage(with: url, options: [
                .processor(processor),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25)),
            ])
        }
    }
}
