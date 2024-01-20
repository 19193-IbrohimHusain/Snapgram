//
//  SearchProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 14/12/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionSearchProduct {
    case main
}

class SearchProductViewModel: BaseViewModel {
    var productData = BehaviorRelay<[ProductModel]?>(value: nil)
    var searchQuery = BehaviorSubject<String?>(value: nil)
    
    func searchProduct(param: ProductParam, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        loadingState.accept(.loading)
        APIManager.shared.fetchProductRequest(endpoint: .products(param: param), expecting: ProductResponse.self) { result in
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                completion(.success(data.data.data))
            case .failure(let error):
                self.loadingState.accept(.failed)
                completion(.failure(error))
            }
        }
    }

    func setupSearch() {
        searchQuery
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[ProductModel]> in
                let param = ProductParam(name: query)
                return Observable.create { observer in
                    self.searchProduct(param: param) { result in
                        switch result {
                        case .success(let products):
                            observer.onNext(products)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { [weak self] products in
                guard let self = self else { return }
                self.productData.accept(products)
            })
            .disposed(by: bag)
    }
}
