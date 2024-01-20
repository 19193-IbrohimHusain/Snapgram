import Foundation

// MARK: - StoryResponse
struct StoryResponse: Codable {
    let error: Bool
    let message: String
    var listStory: [ListStory]
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case listStory
    }
}

// MARK: - ListStory
struct ListStory: Codable, Hashable {
    let id, name, description: String
    let photoURL: String
    let createdAt: String
    let lat, lon: Double?
    var likesCount: Int = 45310
    var commentsCount: Int = 27280
    var isLiked: Bool = false
    var detailUserSection: SectionDetailUser?
    var detailPostSection: SectionDetailUserPost?
    
    static func == (lhs: ListStory, rhs: ListStory) -> Bool {
        return lhs.id == rhs.id && lhs.detailUserSection == rhs.detailUserSection && lhs.detailPostSection == rhs.detailPostSection
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(detailUserSection)
        hasher.combine(detailPostSection)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case photoURL = "photoUrl"
        case createdAt, lat, lon
    }
}
