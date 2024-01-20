//
//  SearchUserViewModel.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import RxSwift
import RxRelay

enum SectionSearchUser {
    case main
}

class SearchUserViewModel: BaseViewModel {
    internal var allData = BehaviorRelay<[ListStory]?>(value: nil)
    internal var searchResult = BehaviorRelay<[ListStory]?>(value: nil)
    internal var searchQuery = BehaviorSubject<String?>(value: nil)
    
    internal func fetchAllData(param: StoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.allData.accept(data.listStory)
                self.loadingState.accept(.finished)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
    
    internal func beginSearch() {
        searchQuery.throttle(.milliseconds(500), scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest { query -> Observable<[ListStory]> in
            return Observable.create { [weak self] observer in
                guard let self = self, let query = query, !query.isEmpty else {
                    self?.searchResult.accept(self?.allData.value)
                    observer.onCompleted()
                    return Disposables.create() }
                let result = self.allData.value?.filter {
                    $0.name.contains(query)
                }
                observer.onNext(result ?? [])
                observer.onCompleted()
                return Disposables.create()
            }
        }.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.searchResult.accept(result)
        }).disposed(by: bag)
    }
}
