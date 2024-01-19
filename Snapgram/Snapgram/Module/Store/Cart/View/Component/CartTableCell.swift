//
//  CartTableCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit
import Kingfisher

protocol CartTableCellDelegate {
    func incrementQty(index: IndexPath)
    func decrementQty(index: IndexPath)
    func addWishlist(index: IndexPath)
    func isExist(index: IndexPath) -> Bool
}

class CartTableCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var decrementBtn: UIButton!
    
    internal var delegate: CartTableCellDelegate?
    internal var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLike()
    }
    
    private func setup() {
        selectionStyle = .none
        productImg.makeCornerRadius(16.0)
        [likeBtn, incrementBtn, decrementBtn].forEach { $0.setAnimateBounce() }
    }
    
    private func configureLike() {
        if let index = indexPath, let isFavorited = self.delegate?.isExist(index: index) {
            likeBtn.tintColor = isFavorited ? .systemRed : .label
            likeBtn.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart"), for: .normal)
        }
    }
    
    internal func configure(with data: Cart) {
        guard let imageUrl = data.image else { return }
        let url = URL(string: imageUrl)
        let size = productImg.bounds.size
        let processor = DownsamplingImageProcessor(size: size)
        productImg.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25))
        ])
        productName.text = data.name
        productPrice.text = "$ \(data.price)"
        productQuantity.text = "\(data.quantity)"
    }
    
    @IBAction func incrementQty(_ sender: UIButton) {
        guard let index = indexPath else { return }
        self.delegate?.incrementQty(index: index)
    }
    
    @IBAction func decrementQty(_ sender: UIButton) {
        guard let index = indexPath else { return }
        self.delegate?.decrementQty(index: index)
    }
    
    @IBAction func likeBtnTap(_ sender: UIButton) {
        guard let index = indexPath else { return }
        self.delegate?.addWishlist(index: index)
    }
}
