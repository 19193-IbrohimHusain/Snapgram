import Foundation

// MARK: - DetailStoryResponse
struct DetailStoryResponse: Codable {
    let error: Bool
    let message: String
    var story: Story
    
    enum CodingKeys: String, CodingKey {
        case error, message
        case story
    }
}

// MARK: - Story
struct Story: Codable {
    let id, name, description: String
    let photoURL: String
    let createdAt: String
    let lat, lon: Double?
    var likesCount: Int = 45310
    var commentsCount: Int = 27280
    var isLiked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case photoURL = "photoUrl"
        case createdAt, lat, lon
    }
}
