import Foundation
import Alamofire

enum EndpointProduct {
    case categories
    case products(param: ProductParam)
    
    var path: String {
        switch self {
        case .categories: return "/categories"
        case .products: return "/products"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .products: return .get
        }
    }
    
    var queryParams: [String: Any]? {
        switch self {
        case .products(let param):
            var params: [String: Any] = [:]
            
            if let id = param.id { params["id"] = id }
            if let limit = param.limit { params["limit"] = limit }
            if let name = param.name { params["name"] = name }
            if let description = param.description { params["description"] = description }
            if let priceFrom = param.priceFrom { params["priceFrom"] = priceFrom }
            if let priceTo = param.priceTo { params["priceTo"] = priceTo }
            if let tags = param.tags { params["tags"] = tags }
            if let categories = param.categories { params["categories"] = categories }
            
            return params
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .categories, .products:
            return URLEncoding.queryString
        }
    }
    
    var urlString: String {
        return BaseConstant.urlProduct + path
    }
}
