//
//  SectionStoreEnum.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

enum SectionStoreCollection: Int, CaseIterable {
    case carousel, popular, forYouProduct
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .carousel:
            return CarouselCollectionCell.self
        case .popular:
            return PopularCollectionCell.self
        case .forYouProduct:
            return FYPCollectionViewCell.self
        }
    }
    
    func registerHeaderFooterTypes(in collectionView: UICollectionView) {
        switch self {
        case .carousel:
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionFooter, CarouselFooter.self)
        case .popular:
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionHeader, PopularHeader.self)
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionFooter, PopularFooter.self)
        case .forYouProduct:
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionHeader, FYPHeader.self)
        }
    }
    
    static var sectionIdentifiers: [SectionStoreCollection: String] {
        return [
            .carousel: String(describing: CarouselCollectionCell.self),
            .popular: String(describing: PopularCollectionCell.self),
            .forYouProduct: String(describing: FYPCollectionViewCell.self)
        ]
    }
}
