//
//  WishlistSection.swift
//  Snapgram
//
//  Created by Phincon on 02/01/24.
//

import Foundation
import Differentiator

struct WishlistSection {
    var section: Int
    var items: [FavoriteProducts]
}

extension WishlistSection: AnimatableSectionModelType {
    typealias Item = FavoriteProducts
    typealias Identity = Int
    
    var identity: Int {
        return section
    }
    
    init(original: WishlistSection, items: [FavoriteProducts]) {
        self = original
        self.items = items
    }
}

extension FavoriteProducts: IdentifiableType {
    public typealias Identity = Int16
    
    public var identity: Int16 { return productID }
    
    
}
