//
//  ExtDetailUser + Delegates.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import UIKit

extension DetailUserViewController: DetailUserPostHeaderCellDelegate {
    func onCategorySelected(index: Int) {
        let section = IndexPath(item: 0, section: 1)
        if let cell = detailUserCollection.cellForItem(at: section) as? DetailUserPostCollectionCell {
            let indexPath = IndexPath(item: 0, section: index)
            cell.detailPostCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension DetailUserViewController: DetailUserPostCollectionCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didScroll(scrollView: UIScrollView) {
        // Update the horizontal bar's frame or constraints based on the new position
        if let header = detailUserCollection.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? DetailUserPostHeaderCell {
            
            // Calculate the x-position for the horizontal bar based on the current content offset
            let xOffset = scrollView.contentOffset.x
            
            // Update the position of the horizontal bar
            header.horizontalBarLeftAnchorConstraint?.constant = xOffset / 2
        }
    }
    
    func didEndDecelerating(scrollView: UIScrollView) {
        if let header = detailUserCollection.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? DetailUserPostHeaderCell {
            let index = Int(scrollView.contentOffset.x / view.frame.width)
            let indexPath = IndexPath(item: index, section: 0)
            header.headerCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}
