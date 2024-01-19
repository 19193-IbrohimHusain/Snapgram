//
//  ProductParam.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation

struct ProductParam {
    var id: Int?
    var limit: Int?
    var name: String?
    var description: String?
    var priceFrom: Int?
    var priceTo: Int?
    var tags: String?
    var categories: Int?
    
    init(id: Int? = nil, limit: Int? = 0, name: String? = nil, description: String? = nil, priceFrom: Int? = nil, priceTo: Int? = nil, tags: String? = nil, categories: Int? = nil) {
        self.id = id
        self.limit = limit
        self.name = name
        self.description = description
        self.priceFrom = priceFrom
        self.priceTo = priceTo
        self.tags = tags
        self.categories = categories
    }
}
