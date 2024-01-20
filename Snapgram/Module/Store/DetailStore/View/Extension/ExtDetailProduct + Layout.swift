//
//  ExtDetailProduct + Layout.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import UIKit
import RxSwift

extension DetailProductViewController {
    internal func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionDetailProduct(rawValue: sectionIndex) else {
                fatalError("Invalid section index")
            }
            
            switch section {
            case .image:
                return self.imageLayout(pagingInfo: self.vm.imagePaging)
            case .name:
                return self.nameLayout()
            case .desc:
                return self.descLayout()
            case .recommendation:
                return self.recommendationLayout()
            }
        })
        
        detailCollection.collectionViewLayout = layout
    }
                       
    private func imageLayout(pagingInfo: BehaviorSubject<PagingInfo?>) -> NSCollectionLayoutSection {
        // Supplementary item for page control
        let pageFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom,
            absoluteOffset: CGPoint(x: 0, y: -40)
        )
        
        let item = NSCollectionLayoutItem.withEntireSize()
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [pageFooter]
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let page = round(offset.x / env.container.contentSize.width)
            pagingInfo.onNext(PagingInfo(sectionIndex: 0, currentPage: Int(page)))
        }
        return section
    }
    
    private func nameLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func descLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func recommendationLayout() -> NSCollectionLayoutSection {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let item = NSCollectionLayoutItem.withEntireSize()
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 100, trailing: 16)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}
