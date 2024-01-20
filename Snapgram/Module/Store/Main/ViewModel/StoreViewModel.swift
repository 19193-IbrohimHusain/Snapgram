//
//  StoreViewModel.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation
import RxSwift
import RxRelay

class StoreViewModel: BaseViewModel {
    var productData = BehaviorRelay<[ProductModel]?>(value: nil)
    var sportShoes = BehaviorRelay<[ProductModel]?>(value: nil)
    var categoryData = BehaviorRelay<[CategoryModel]?>(value: nil)
    var pagingCarousel = BehaviorSubject<PagingInfo?>(value: nil)
    var pagingPopular = BehaviorSubject<PagingInfo?>(value: nil)
    
    func fetchProduct(param: ProductParam = ProductParam()) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.productData.accept(data.data.data)
                let sportShoes = data.data.data.filter {
                    $0.category.name == "Sport"
                }
                self.sportShoes.accept(sportShoes)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func fetchCategories() {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .categories, expecting: CategoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.categoryData.accept(data.data.data)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
            
        }
    }
}
