//
//  DetailProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailProductViewModel: BaseViewModel {
    internal var dataProduct = BehaviorRelay<ProductModel?>(value: nil)
    internal var recommendation = BehaviorRelay<[ProductModel]?>(value: nil)
    internal var imagePaging = BehaviorSubject<PagingInfo?>(value: nil)
    
    internal func fetchDetailProduct(param: ProductParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: DetailProductResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.dataProduct.accept(data.data)
                self.loadingState.accept(.finished)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
    
    internal func fetchRecommendationProduct(param: ProductParam = ProductParam()) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.recommendation.accept(data.data.data)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
    
    internal func isItemExist(product: ProductModel?) -> Bool {
        guard let product = product, let user = try? BaseConstant.getUserFromUserDefaults() else { return false }
        let result = CoreDataHelper.shared.isEntityExist(FavoriteProducts.self, productId: product.id, userId: user.userid)
        return result
    }
    
    internal func addItemToCoreData(for action: ProductCoreData, product: ProductModel, image: [GalleryModel]?) -> CoreDataResult {
        guard let user = try? BaseConstant.getUserFromUserDefaults(), let image = image?.first else { return .failed }
        switch action {
        case .cart(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(id),
                "name": product.name,
                "image": image.url,
                "price": product.price,
                "quantity": 1,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(Cart.self, for: .cart(id: id), productId: id, userId: user.userid, properties: properties, isIncrement: true)
        case .favorite(let id):
            let properties: [String: Any] = [
                "userID": user.userid,
                "productID": Int16(id),
                "name": product.name,
                "imageLink": image.url,
                "price": product.price,
            ]
            return CoreDataHelper.shared.addOrUpdateEntity(FavoriteProducts.self, for: .favorite(id: id), productId: id, userId: user.userid, properties: properties, isIncrement: false)
        }
    }
}
