import Foundation
import netfox

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    enum APIError: Error {
        case failedToCreateRequest
        case failedToGetData
        case requestTimedOut
    }
    
    public func fetchRequest<T: Codable>(endpoint: EndpointStory, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(endpoint: endpoint) else {
            completion(.failure(APIError.failedToCreateRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                if let nsError = error as NSError?, nsError.code == NSURLErrorTimedOut {
                    completion(.failure(APIError.requestTimedOut))
                } else {
                    completion(.failure(APIError.failedToGetData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func request(endpoint: EndpointStory) -> URLRequest? {
        guard let url = URL(string: endpoint.urlString) else { return nil }
        
        var request = URLRequest(url: endpoint.method == "GET" ? finalURL(with: endpoint, base: url) : url)
        request.httpMethod = endpoint.method
        request.timeoutInterval = 30
        
        setHeaders(for: &request, with: endpoint)
        
        if endpoint.method == "POST" {
            setBody(for: &request, with: endpoint)
        }
        
        return request
    }
    
    private func finalURL(with endpoint: EndpointStory, base: URL) -> URL {
        guard let queryItems = endpoint.queryParam?.map({ URLQueryItem(name: $0, value: "\($1)") }) else {
            return base
        }
        
        return base.appendingQueryItems(queryItems)
    }
    
    private func setHeaders(for request: inout URLRequest, with endpoint: EndpointStory) {
        endpoint.headers?.forEach { key, value in
            request.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    private func setBody(for request: inout URLRequest, with endpoint: EndpointStory) {
        switch endpoint {
        case .addNewStory(let param):
            setMultipartFormData(for: &request, with: param)
        case .login, .register:
            setJSONBody(for: &request, with: endpoint.bodyParam)
        default:
            break
        }
    }
    
    private func setMultipartFormData(for request: inout URLRequest, with param: AddStoryParam) {
        let boundary = UUID().uuidString
        var body = Data()
        let mirror = Mirror(reflecting: param)

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for case let (label?, value) in mirror.children {
            switch label {
            case "description":
                if let stringValue = value as? String {
                    body.append(convertFormField(named: label, value: stringValue, using: boundary))
                }
                
            case "photo":
                if let image = value as? UIImage, let imageData = image.jpegData(compressionQuality: 0.5) {
                    body.append(multipartFormData(withName: label, fileName: "image.png", mimeType: "image/png", using: boundary))
                    body.append(imageData)
                }
                
            case "lat", "lon":
                if let floatValue = value as? Float {
                    body.append(convertLatLonToRequestBody(label, value: floatValue, using: boundary))
                }
            
            default:
                break
            }
        }
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
    }
    
    private func setJSONBody(for request: inout URLRequest, with bodyParam: [String: Any]?) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyParam as Any) else { return }
        request.httpBody = jsonData
    }
    
    private func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        fieldString += "\(value)"
        return fieldString.data(using: .utf8)!
    }
    
    private func multipartFormData(withName name: String, fileName: String, mimeType: String, using boundary: String) -> Data {
        let body = NSMutableData()
        
        if let imageDataPart = "\r\n--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\nContent-Type: \(mimeType)\r\n\r\n".data(using: .utf8) {
            body.append(imageDataPart)
        }
        return body as Data
    }
    
    private func convertLatLonToRequestBody(_ name: String, value: Float, using boundary: String) -> Data {
        var fieldString = "\r\n--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        fieldString += "\(value)"
        return fieldString.data(using: .utf8)!
    }
}

extension URL {
    func appendingQueryItems(_ queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url ?? self
    }
}
