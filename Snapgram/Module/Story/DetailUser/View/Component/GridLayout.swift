//
//  GridLayout.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import Foundation
import UIKit

public final class GridLayout {
    public static func makeLayoutSection(
        config: Configuration,
        enviroment: NSCollectionLayoutEnvironment,
        sectionIndex: Int
    ) -> NSCollectionLayoutSection {
        
        // NSCollectionLayoutGroupCustomItem to create layout with custom frames
        var items = [NSCollectionLayoutGroupCustomItem]()
        
        
        let itemProvider = LayoutBuilder(
            configuration: config,
            collectionWidth: enviroment.container.contentSize.width
        )
        
        for i in 0..<config.itemCountProvider() {
            let item = itemProvider.makeLayoutItem(for: i)
            items.append(item)
        }
        
        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(itemProvider.maxColumnHeight())
        )
        
        let group = NSCollectionLayoutGroup.custom(layoutSize: groupLayoutSize) { _ in
            return items
        }
                
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsetsReference = config.contentInsetsReference

        return section
    }
}

public extension GridLayout {
    typealias ItemHeightProvider = (_ index: Int, _ itemWidth: CGFloat) -> CGFloat
    typealias ItemCountProvider = () -> Int
    
    struct Configuration {
        public let columnCount: Int
        public let interItemSpacing: CGFloat
        public let sectionHorizontalSpacing: CGFloat
        public let contentInsetsReference: UIContentInsetsReference
        public let itemHeightProvider: ItemHeightProvider
        public let itemCountProvider: ItemCountProvider
            
        public init(
            columnCount: Int = 3,
            interItemSpacing: CGFloat = 1.0,
            sectionHorizontalSpacing: CGFloat = 0.0,
            contentInsetsReference: UIContentInsetsReference = .automatic,
            itemCountProvider: @escaping ItemCountProvider,
            itemHeightProvider: @escaping ItemHeightProvider
        ) {
            self.columnCount = columnCount
            self.interItemSpacing = interItemSpacing
            self.sectionHorizontalSpacing = sectionHorizontalSpacing
            self.contentInsetsReference = contentInsetsReference
            self.itemCountProvider = itemCountProvider
            self.itemHeightProvider = itemHeightProvider
        }
    }
}


extension GridLayout {
    final class LayoutBuilder {
        private var columnHeights: [CGFloat]
        private let columnCount: CGFloat
        private let itemHeightProvider: ItemHeightProvider
        private let interItemSpacing: CGFloat
        private let sectionHorizontalSpacing: CGFloat
        private let collectionWidth: CGFloat
        
        init(
            configuration: Configuration,
            collectionWidth: CGFloat
        ) {
            self.columnHeights = [CGFloat](repeating: 0, count: configuration.columnCount)
            self.columnCount = CGFloat(configuration.columnCount)
            self.itemHeightProvider = configuration.itemHeightProvider
            self.interItemSpacing = configuration.interItemSpacing
            self.sectionHorizontalSpacing = configuration.sectionHorizontalSpacing
            self.collectionWidth = collectionWidth
        }
        
        func makeLayoutItem(for row: Int) -> NSCollectionLayoutGroupCustomItem {
            let frame = frame(for: row)
            columnHeights[columnIndex()] = frame.maxY + interItemSpacing
            return NSCollectionLayoutGroupCustomItem(frame: frame)
        }
        
        func maxColumnHeight() -> CGFloat {
            return columnHeights.max() ?? 0
        }
    }
}

private extension GridLayout.LayoutBuilder {
    private var columnWidth: CGFloat {
        return collectionWidth / columnCount
    }
    
    func frame(for row: Int) -> CGRect {
        let width = columnWidth
        let height = itemHeightProvider(row, width)
        let size = CGSize(width: width, height: height)
        let origin = itemOrigin(width: size.width)
        return CGRect(origin: origin, size: size)
    }
    
    private func itemOrigin(width: CGFloat) -> CGPoint {
        let y = columnHeights[columnIndex()].rounded()
        let x = (width + interItemSpacing) * CGFloat(columnIndex())
        return CGPoint(x: x, y: y)
    }
    
    private func columnIndex() -> Int {
        columnHeights
            .enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
}

