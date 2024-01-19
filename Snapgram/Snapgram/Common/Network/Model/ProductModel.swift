import Foundation

struct ProductResponse: Codable {
    let meta: Meta
    let data: ProductData
    
    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}

struct Meta: Codable {
    let code: Int
    let status, message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case status, message
    }
}

// MARK: - DataClass
struct ProductData: Codable {
    let currentPage: Int
    let data: [ProductModel]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
    }
}

struct ProductModel: Codable, Hashable {
    var id: Int
    let name: String
    let price: Double
    let description: String
    let tags: String?
    let categoriesId: Int
    let category: CategoryModel
    let galleries: [GalleryModel]?
    var cellTypes: SectionStoreCollection?
    var fypSection: SectionFYPCollection?
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.cellTypes == rhs.cellTypes && lhs.fypSection == rhs.fypSection
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cellTypes)
        hasher.combine(fypSection)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, description, tags, category, galleries
        case categoriesId = "categories_id"
    }
}

struct GalleryModel: Codable, Hashable {
    let id: Int
    let productsId: Int
    let url: String
    
    static func == (lhs: GalleryModel, rhs: GalleryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case productsId = "products_id"
    }
}
