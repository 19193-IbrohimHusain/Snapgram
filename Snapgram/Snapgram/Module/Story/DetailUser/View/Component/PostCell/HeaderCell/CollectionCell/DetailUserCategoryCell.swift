//
//  DetailUserCategoryCell.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import UIKit

protocol DetailUserCategoryCellDelegate {
    func onCategorySelected(index: Int)
}

class DetailUserCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryBtn: UIButton!
    
    var index: Int = Int()
    var delegate: DetailUserCategoryCellDelegate?
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .separator
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBtn.tintColor = .separator
    }
    
    internal func configure(with image: DetailUserCategoryEntity) {
        categoryBtn.setImage(UIImage(systemName: image.image), for: .normal)
    }

    @IBAction func onCategoryBtnTap(_ sender: UIButton) {
        self.delegate?.onCategorySelected(index: index)
    }
}
