import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel : BaseViewModel {
    var registerResponse = BehaviorRelay<RegisterResponse?>(value: nil)
    
    func signUp(param: RegisterParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .register(param: param), expecting: RegisterResponse.self) { result in
            switch result {
            case .success(let response):
                if response.error == true {
                    self.loadingState.accept(.failed)
                    self.registerResponse.accept(response)
                } else {
                    self.loadingState.accept(.finished)
                    self.registerResponse.accept(response)
                }
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
    
