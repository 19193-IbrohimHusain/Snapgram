//
//  ExtNSCollectionLayoutItem.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit
import RxSwift

extension NSCollectionLayoutItem {
    static func withEntireSize() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
    
    static func entireWidth(withHeight height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
    
    static func entireHeight(withWidth width: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}

extension NSCollectionLayoutSection {
    
    static func listSection(withEstimatedHeight estimatedHeight: CGFloat = 100) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = .fixed(10)
        
        return NSCollectionLayoutSection(group: layoutGroup)
    }
    
    static func searchSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1.0))
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .horizontalInsets(size: 16)
        
        return section
    }
    
    static func carouselSection(pagingInfo: BehaviorSubject<PagingInfo?>) -> NSCollectionLayoutSection {
        // Supplementary item for page control
        let pageControlItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom,
            absoluteOffset: CGPoint(x: 0, y: -40)
        )
        
        let item = NSCollectionLayoutItem.withEntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [pageControlItem]
        section.interGroupSpacing = 8
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let page = round(offset.x / env.container.contentSize.width)
            pagingInfo.onNext(PagingInfo(sectionIndex: 1, currentPage: Int(page)))
        }
        
        return section
    }
    
    static func popularListSection(pagingInfo: BehaviorSubject<PagingInfo?>) -> NSCollectionLayoutSection {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1/3))
        item.contentInsets = .verticalInsets(size: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(345))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header, footer]
        section.interGroupSpacing = 16
        section.contentInsets =  NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let page = round(offset.x / env.container.contentSize.width)
            pagingInfo.onNext(PagingInfo(sectionIndex: 2, currentPage: Int(page)))
        }
        return section
    }
    
    static func forYouPageSection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let item = NSCollectionLayoutItem.withEntireSize()
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(env.container.contentSize.height * 3 + 150))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .horizontalInsets(size: 16)
        section.boundarySupplementaryItems = [header]
        section.boundarySupplementaryItems[0].pinToVisibleBounds = true
        
        return section
    }
    
    static func createFYPLayout(env: NSCollectionLayoutEnvironment, items: [ProductModel], section: Int, sectionHorizontalSpacing: CGFloat = 4, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0) -> NSCollectionLayoutSection {
        
        let layout = FYPLayout.makeLayoutSection(
            config: .init(
                columnCount: 2,
                interItemSpacing: 10,
                sectionHorizontalSpacing: sectionHorizontalSpacing,
                itemCountProvider:  {
                    return items.count
                },
                itemHeightProvider: { index, itemWidth in
                    var randomHeight = CGFloat()
                    items.forEach { _ in
                        randomHeight = CGFloat.random(in: 300...350)
                    }
                    return CGFloat(randomHeight)
                }),
            enviroment: env, sectionIndex: section
        )
        
        layout.contentInsets = .init(
            top: top,
            leading: leading,
            bottom: 0,
            trailing: trailing
        )
        
        return layout
    }
    
    static func largeGridSection(itemInsets: NSDirectionalEdgeInsets = .uniform(size: 5)) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInsets
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
