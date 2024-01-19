import RxSwift
import RxCocoa

class DetailStoryViewModel : BaseViewModel {
    var detailStoryData = BehaviorRelay<DetailStoryResponse?>(value: nil)
    
    func fetchDetailStory(param: String) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .getDetailStory(param), expecting: DetailStoryResponse.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.detailStoryData.accept(data)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
