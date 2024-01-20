import Foundation
import RxSwift
import RxCocoa

enum SectionProfileTable: Int, CaseIterable {
    case profile, category, post
    
    internal var cellTypes: UITableViewCell.Type {
        switch self {
        case .profile:
            return ProfileTableCell.self
        case .category:
            return CategoryTableCell.self
        case .post:
            return PostTableCell.self
        }
    }
}

enum SectionPostCollection: Int, CaseIterable {
    case post, tagged
    
    internal var cellTypes: UICollectionViewCell.Type {
        switch self {
        case .post:
            return PostCollectionCell.self
        case .tagged:
            return TaggedPostCollectionCell.self
        }
    }
}

class ProfileViewModel : BaseViewModel {
    internal var userPost = BehaviorRelay<[ListStory]?>(value: nil)
    internal var taggedPost = BehaviorRelay<[ListStory]?>(value: nil)
    internal var currentUser = BehaviorRelay<User?>(value: nil)
    
    func fetchStory(param: StoryParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchStory(param: param), expecting: StoryResponse.self) { [weak self] result in
            guard let self = self, let user = try? BaseConstant.getUserFromUserDefaults() else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                let tagData = Array(data.listStory.prefix(200))
                self.taggedPost.accept(tagData)
                self.currentUser.accept(user)
                let story = data.listStory
                let filteredStory = story.filter { $0.name == self.currentUser.value?.username }
                self.userPost.accept(filteredStory)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
