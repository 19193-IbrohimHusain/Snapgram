//
//  StoreViewDataSource.swift
//  Snapgram
//
//  Created by Phincon on 15/12/23.
//

import Foundation
import UIKit
import SkeletonView


class StoreViewDataSource: UICollectionViewDiffableDataSource<SectionStoreCollection, ProductModel>, SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return SectionStoreCollection.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SectionStoreCollection(rawValue: section) {
        case .carousel:
            return 1
        case .popular:
            return 6
        case .forYouProduct:
            return 1
        default: return 1
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let collection = SectionStoreCollection(rawValue: indexPath.section)
        guard let section = collection else { return "" }
        
        if let identifier = SectionStoreCollection.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}

class FYPCollectionViewDataSource: UICollectionViewDiffableDataSource<SectionFYPCollection, ProductModel>, SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return SectionFYPCollection.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: FYPCollectionCell.self)
    }
}
