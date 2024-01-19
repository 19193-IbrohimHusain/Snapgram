import Foundation

class BaseConstant {
    static let urlStory: String = "https://story-api.dicoding.dev/v1"
    static let urlProduct: String = "https://shoe121231.000webhostapp.com/api"
    static let fpcCornerRadius: CGFloat = 24.0
    static let userDef = UserDefaults.standard
    static private let userData = "userData"
    
    static func saveUserToUserDefaults(user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            userDef.set(userData, forKey: self.userData)
        } catch {
            print("Error encoding user data: \(error)")
        }
    }
    
    static func getUserFromUserDefaults() throws -> User {
        if let savedUser = userDef.data(forKey: userData),
           let user = try? JSONDecoder().decode(User.self, from: savedUser) {
            return user
        } else {
            throw NSError(domain: "UserFetchError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error fetching or decoding User"])
        }
    }
    
    static func deleteUserFromUserDefaults() {
        userDef.removeObject(forKey: userData)
    }
}


class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
