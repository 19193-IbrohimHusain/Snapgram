//
//  WishlistViewModel.swift
//  Snapgram
//
//  Created by Phincon on 29/12/23.
//

import Foundation
import RxRelay

class WishlistViewModel: BaseViewModel {
    internal var favProduct = BehaviorRelay<[FavoriteProducts]>(value: [])
    
    internal func fetchFavProduct() {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        if let items = try? CoreDataHelper.shared.fetchItems(FavoriteProducts.self, userId: user.userid) {
            favProduct.accept(items)
        }
    }
    
    internal func deleteItems(indexPath: IndexPath) {
        let item = favProduct.value[indexPath.row]
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let name = item.name, let imageLink = item.imageLink else { return }
        let properties: [String: Any] = [
            "userID": user.userid,
            "productID": item.productID,
            "name": name,
            "imageLink": imageLink,
            "price": item.price,
        ]
        
        let state = CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(id: Int(item.productID)), productId: Int(item.productID), userId: user.userid, properties: properties, isIncrement: false)
        if state == .deleted { self.fetchFavProduct() }
    }
}
