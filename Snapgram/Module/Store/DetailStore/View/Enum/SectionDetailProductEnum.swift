//
//  SectionDetailProductEnum.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

enum SectionDetailProduct: Int, CaseIterable {
    case image, name, desc, recommendation
    
    var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .image:
            return ImageCell.self
        case .name:
            return NameCell.self
        case .desc:
            return DescriptionCell.self
        case .recommendation:
            return FYPCollectionCell.self
        }
    }
    
    func registerHeaderFooterTypes(in collectionView: UICollectionView) {
        switch self {
        case .image:
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionFooter, ImageFooter.self)
        case .recommendation:
            collectionView.registerHeaderFooterNib(kind: UICollectionView.elementKindSectionHeader, RecommendationHeader.self)
        default: break
        }
    }
    
    static var sectionIdentifiers: [SectionDetailProduct: String] {
        return [
            .image: String(describing: ImageCell.self),
            .name: String(describing: NameCell.self),
            .desc: String(describing: DescriptionCell.self),
            .recommendation: String(describing: FYPCollectionCell.self),
        ]
    }
}
