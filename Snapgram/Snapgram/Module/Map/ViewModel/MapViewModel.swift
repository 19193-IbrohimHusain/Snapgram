import RxSwift
import RxCocoa

class MapViewModel: BaseViewModel {
    internal var mapData = BehaviorRelay<StoryResponse?>(value: nil)
    
    internal func fetchLocationStory(param: StoryParam) {
        loadingState.accept(.notLoad)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.mapData.accept(data)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
    
