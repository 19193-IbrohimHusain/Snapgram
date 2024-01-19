//
//  ExtDetailProduct + DataSource.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import Foundation
import UIKit
import SkeletonView

extension DetailProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = SectionDetailProduct(rawValue: section)
        switch section {
        case .image:
            return  image?.count ?? 3
        case .name, .desc:
            return 1
        case .recommendation:
            return  recommendation?.count ?? 3
        default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = SectionDetailProduct(rawValue: indexPath.section)
        switch section {
        case .image:
            let cell: ImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let image = image?[indexPath.item] {
                cell.configure(with: image)
                cell.hideSkeleton()
            }
            return cell
        case .name:
            let cell1: NameCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = product {
                cell1.configure(with: product)
                cell1.delegate = self
            }
            return cell1
        case .desc:
            let cell2: DescriptionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = product {
                cell2.configure(with: product)
            }
            return cell2
        case .recommendation:
            let cell3: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = recommendation?[indexPath.item] {
                cell3.configure(with: product)
                cell3.hideSkeleton()
            }
            return cell3
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = SectionDetailProduct(rawValue: indexPath.section)
        switch section {
            case .image:
                let footer: ImageFooter = collectionView.dequeueHeaderFooterCell(
                    kind: UICollectionView.elementKindSectionFooter,
                    forIndexPath: indexPath
                )
                footer.subscribeTo(subject: vm.imagePaging, for: collections[0].rawValue)
                currentIndex = footer.pageControl.currentPage
                return footer
            case .recommendation:
                let header: RecommendationHeader = collectionView.dequeueHeaderFooterCell(
                    kind: UICollectionView.elementKindSectionHeader,
                    forIndexPath: indexPath
                )
                return header
            default: return UICollectionReusableView()
        }
    }
}

extension DetailProductViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return collections.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collection = SectionDetailProduct(rawValue: section)
        switch collection {
        case .image, .name,.desc:
            return 1
        case .recommendation:
            return 2
        default: return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let collection = SectionDetailProduct(rawValue: indexPath.section)
        guard let section = collection else { return "" }
        
        if let identifier = SectionDetailProduct.sectionIdentifiers[section] {
            return identifier
        } else {
            return ""
        }
    }
}
