import UIKit
import RxSwift
import RxRelay

class AddStoryViewModel: BaseViewModel{
    var addStory = BehaviorRelay<AddStoryResponse?>(value: nil)
    
    func postStory(param: AddStoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .addNewStory(param: param), expecting: AddStoryResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.error == true {
                    self.loadingState.accept(.failed)
                    self.addStory.accept(response)
                } else {
                    self.loadingState.accept(.finished)
                    self.addStory.accept(response)
                }
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
