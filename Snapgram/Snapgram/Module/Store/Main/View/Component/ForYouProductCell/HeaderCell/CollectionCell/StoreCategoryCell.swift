//
//  CategoryCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit

class StoreCategoryCell: UICollectionViewCell {

    @IBOutlet private weak var categoryBtn: UIButton!
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .separator
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBtn.tintColor = .separator
    }

    internal func configure(data category: CategoryModel) {
        categoryBtn.setTitle(category.name, for: .normal)
    }
}
