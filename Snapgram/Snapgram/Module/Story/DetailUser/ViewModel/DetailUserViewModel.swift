//
//  DetailUserViewModel.swift
//  Snapgram
//
//  Created by Phincon on 19/12/23.
//

import Foundation
import RxSwift
import RxRelay

class DetailUserViewModel: BaseViewModel {
    var userName: String?
    var userPost = BehaviorRelay<[ListStory]?>(value: nil)
    var tagPost = BehaviorRelay<[ListStory]?>(value: nil)
    
    func fetchAllPost(param: StoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self, let userName = self.userName else { return }
            switch result {
            case .success(let data):
                let tagData = Array(data.listStory.prefix(200))
                self.tagPost.accept(tagData)
                let result = data.listStory.filter {
                    $0.name == userName
                }
                self.userPost.accept(result)
                self.loadingState.accept(.finished)
            case.failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
