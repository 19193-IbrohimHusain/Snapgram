import Foundation

// MARK: - AddStoryResponse
struct AddStoryResponse: Codable {
    let error: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case error, message
    }
}
