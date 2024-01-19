//
//  CartViewModel.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation
import RxRelay
enum SectionCartTable {
    case main
}

class CartViewModel: BaseViewModel {
    internal var cartItems = BehaviorRelay<[Cart]?>(value: nil)
    
    internal func fetchCartItems() {
        guard let user = try? BaseConstant.getUserFromUserDefaults() else { return }
        let items = try? CoreDataHelper.shared.fetchItems(Cart.self, userId: user.userid)
        cartItems.accept(items)
    }
    
    internal func isItemExist(snapshot: NSDiffableDataSourceSnapshot<SectionCartTable, Cart>, index: IndexPath) -> Bool {
        guard !snapshot.itemIdentifiers.isEmpty, let user = try? BaseConstant.getUserFromUserDefaults() else { return false }
        let item = snapshot.itemIdentifiers[index.item]
        let result = CoreDataHelper.shared.isEntityExist(FavoriteProducts.self, productId: Int(item.productID), userId: user.userid)
        return result
    }
    
    internal func addOrUpdateItemToCoreData(for action: ProductCoreData, indexPath: IndexPath, dataSource: UITableViewDiffableDataSource<SectionCartTable, Cart>, isIncrement: Bool) -> CoreDataResult {
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let item = dataSource.itemIdentifier(for: indexPath), let imageUrl = item.image, let name = item.name else { return .failed }
        switch action {
        case .cart(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(id),
                "name": name,
                "image": imageUrl,
                "price": item.price,
                "quantity": 1,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(Cart.self, for: .cart(id: id), productId: id, userId: user.userid, properties: properties, isIncrement: isIncrement)
        case .favorite(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": item.productID,
                "name": name,
                "imageLink": imageUrl,
                "price": item.price,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(id: id), productId: id, userId: user.userid, properties: properties, isIncrement: false)
        }
    }
}
