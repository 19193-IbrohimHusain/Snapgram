//
//  CategoryModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation

struct CategoryResponse: Codable {
    let meta: Meta
    let data: CategoryData
    
    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}

// MARK: - DataClass
struct CategoryData: Codable {
    let data: [CategoryModel]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CategoryModel: Codable, Hashable {
    let id: Int
    let name: String
    
    // Custom implementation of the equality operator
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Implementation of the hash(into:) method
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
