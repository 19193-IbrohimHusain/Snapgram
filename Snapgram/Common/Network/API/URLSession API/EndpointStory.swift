import Foundation

enum EndpointStory {
    case login(param: LoginParam)
    case register(param: RegisterParam)
    case fetchStory(param: StoryParam)
    case getDetailStory(String)
    case addNewStory(param: AddStoryParam)
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .register: return "/register"
        case .fetchStory: return "/stories"
        case .getDetailStory(let id): return "/stories/\(id)"
        case .addNewStory: return "/stories"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register, .addNewStory: return "POST"
        case .fetchStory, .getDetailStory: return "GET"
        }
    }
    
    var bodyParam: [String: Any]? {
        switch self {
        case .fetchStory, .getDetailStory: return nil
        case .addNewStory(let param):
            let params: [String: Any] = [
                "description": param.description,
                "photo": param.photo,
                "lat": param.lat ?? 0.0,
                "lon": param.lon ?? 0.0
            ]
            return params
        case .register(let param):
            let params: [String: Any] = [
                "name" : param.name,
                "email" : param.email,
                "password" : param.password
            ]
            return params
        case .login(let param):
            let params: [String: Any] = [
                "email": param.email,
                "password": param.password
            ]
            return params
        }
    }
    
    var queryParam: [String: Any]? {
        switch self {
        case .addNewStory, .getDetailStory, .register, .login: return nil
        case .fetchStory(let param):
            return [
                "page": param.page,
                "size": param.size,
                "location": param.location
            ]
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .login, .register: return nil
        case .addNewStory:
            return ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(retrieveToken())"]
        case .fetchStory, .getDetailStory: return ["Authorization": "Bearer \(retrieveToken())"]
        }
    }
    
    private func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            print("Token not found in Keychain")
            return ""
        }
    }
    
    var urlString: String {
        return BaseConstant.urlStory + path
    }
}
