import Foundation
import RxSwift
import RxCocoa

class LoginViewModel : BaseViewModel {
    var loginResponse = BehaviorRelay<LoginResponse?>(value: nil)
    
    func signIn(param: LoginParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .login(param: param), expecting: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                self.loginResponse.accept(response)
                self.loadingState.accept(response.error ? .failed : .finished)
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
    
