//
//  PopularProductDataSource.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import SkeletonView

class PopularProductDataSource: UICollectionViewDiffableDataSource<SectionPopularProduct, ProductModel>, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularEntity.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: FYPCollectionCell.self)
    }
}
