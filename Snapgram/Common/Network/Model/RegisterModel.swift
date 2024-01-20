import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let error: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case error, message
    }
}
