//
//  PopularHeader.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit

protocol PopularHeaderDelegate {
    func navigateToPopular()
}

class PopularHeader: UICollectionReusableView {

    @IBOutlet weak var navigateBtn: UIButton!
    
    internal var delegate: PopularHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigateBtn.setAnimateBounce()
    }
    
    @IBAction private func navigate() {
        self.delegate?.navigateToPopular()
    }
}
