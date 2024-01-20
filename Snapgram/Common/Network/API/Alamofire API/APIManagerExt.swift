//
//  APIManagerExt.swift
//  Snapgram
//
//  Created by Phincon on 30/11/23.
//

import Foundation
import Alamofire

extension APIManager {
    public func fetchProductRequest<T: Codable>(endpoint: EndpointProduct, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(endpoint.urlString,
                   method: endpoint.method,
                   parameters: endpoint.queryParams,
                   encoding: endpoint.encoding)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let item):
                completion(.success(item))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
