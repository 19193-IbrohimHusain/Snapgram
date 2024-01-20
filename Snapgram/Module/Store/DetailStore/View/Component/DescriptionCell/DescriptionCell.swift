//
//  DescriptionCell.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import UIKit

class DescriptionCell: UICollectionViewCell {

    @IBOutlet weak var productDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func configure (with product: ProductModel) {
        productDesc.text = product.description.replacingOccurrences(of: "\r\n", with: "")
    }
}
