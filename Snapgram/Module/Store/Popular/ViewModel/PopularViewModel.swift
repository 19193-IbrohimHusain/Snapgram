//
//  PopularViewModel.swift
//  Snapgram
//
//  Created by Phincon on 14/12/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionPopularProduct {
    case main
}

class PopularProductViewModel: BaseViewModel {
    var productData = BehaviorRelay<[ProductModel]?>(value: nil)
    
    func getProduct(param: ProductParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.productData.accept(data.data.data)
                self.loadingState.accept(.finished)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
