//
//  ExtStore + CellDelegate.swift
//  Snapgram
//
//  Created by Phincon on 15/12/23.
//

import Foundation

extension StoreViewController: FYPCollectionViewCellDelegate {
    func handleNavigate(index: Int) {
        self.navigateToDetail(index: index)
    }
    
    func willEndDragging(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        if let headerFYP = self.headerFYP {
            headerFYP.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            let sectionIndex = IndexPath(item: 0, section: 2)
            storeCollection.scrollToItem(at: sectionIndex, at: .top, animated: true)
        }
    }
}

extension StoreViewController: FYPHeaderDelegate {
    private func scrollToMenuIndex(index: Int) {
        let sectionIndex = IndexPath(item: 0, section: 2)
        if let cell = storeCollection.cellForItem(at: sectionIndex) as? FYPCollectionViewCell {
            cell.fypCollection.scrollToItem(at: IndexPath(item: 0, section: index), at: .centeredHorizontally, animated: true)
        }
        storeCollection.scrollToItem(at: sectionIndex, at: .top, animated: true)
    }
    
    func setCurrentSection(index: Int) {
        self.scrollToMenuIndex(index: index)
    }
}

extension StoreViewController: PopularHeaderDelegate {
    func navigateToPopular() {
        let vc = PopularProductViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
