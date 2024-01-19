//
//  ExtCart + BindData.swift
//  Snapgram
//
//  Created by Phincon on 04/01/24.
//

import Foundation

extension CartViewController: CartTableCellDelegate {
    func incrementQty(index: IndexPath) {
        if let item = dataSource.itemIdentifier(for: index) {
            weak let _ = vm.addOrUpdateItemToCoreData(for: .cart(id: Int(item.productID)), indexPath: index, dataSource: self.dataSource, isIncrement: true)
            clearSnapshot() { self.vm.fetchCartItems() }
        }
    }
    
    func decrementQty(index: IndexPath) {
        if let item = dataSource.itemIdentifier(for: index) {
            let state = vm.addOrUpdateItemToCoreData(for: .cart(id: Int(item.productID)), indexPath: index, dataSource: self.dataSource, isIncrement: false)
            if state == .deleted {
                self.resultHandler(for: state, destination: "Cart", item: item)
            } else {
                clearSnapshot() { self.vm.fetchCartItems() }
            }
        }
    }
    
    func addWishlist(index: IndexPath) {
        if let item = self.dataSource.itemIdentifier(for: index) {
            let state = vm.addOrUpdateItemToCoreData(for: .favorite(id: Int(item.productID)), indexPath: index, dataSource: self.dataSource, isIncrement: false)
            self.resultHandler(for: state, destination: "Wishlist", item: item)
        }
    }
    
    func isExist(index: IndexPath) -> Bool {
        return vm.isItemExist(snapshot: self.snapshot, index: index)
    }
}
