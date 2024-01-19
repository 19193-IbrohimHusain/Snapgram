//
//  DetailProductResponse.swift
//  Snapgram
//
//  Created by Phincon on 18/12/23.
//

import Foundation

struct DetailProductResponse: Codable {
    let meta: Meta
    let data: ProductModel
    
    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}
