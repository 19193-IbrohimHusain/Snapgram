//
//  ExtDetailUser + Layout.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

extension DetailUserViewController {
    internal func setupCompositionalLayout() {
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionDetailUser(rawValue: sectionIndex) else {
                fatalError("Invalid section index")
            }
            
            switch section {
            case .profile:
                return self.profileLayout()
            case .post:
                return self.postLayout(env: env)
            }
        })
        
        detailUserCollection.collectionViewLayout = layout
    }
    
    private func profileLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(257))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func postLayout(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let item = NSCollectionLayoutItem.withEntireSize()
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(env.container.effectiveContentSize.height * 11))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.boundarySupplementaryItems[0].pinToVisibleBounds = true
        
        return section
    }
}
