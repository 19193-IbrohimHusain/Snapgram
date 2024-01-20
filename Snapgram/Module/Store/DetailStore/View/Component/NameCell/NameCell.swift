//
//  DetailNameCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

protocol NameCellDelegate {
    func addFavorite()
    func checkIsFavorite() -> Bool
}

class NameCell: UICollectionViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var soldAmount: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var reviewerPhotoBtn: UIButton!
    @IBOutlet weak var discussionBtn: UIButton!
    
    internal var delegate: NameCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setLikeBtn()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private func setup() {
        reviewBtn.imageView?.tintColor = .systemYellow
        [reviewerPhotoBtn, discussionBtn].forEach {$0?.imageView?.tintColor = .systemGray}
        likeBtn.setAnimateBounce()
    }
    
    internal func configure(with product: ProductModel) {
        productName.text = product.name
        productPrice.text = "$ \(product.price)"
    }
    
    private func setLikeBtn() {
        if let isFavorited = self.delegate?.checkIsFavorite() {
            likeBtn.setImage(isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
            likeBtn.tintColor = isFavorited ? .systemRed : .label
        }
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        self.delegate?.addFavorite()
    }
    
}
