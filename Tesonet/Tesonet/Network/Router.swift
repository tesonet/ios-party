import Alamofire

enum Router: URLRequestConvertible {
    case login(username: String, password: String)
    case servers(token: String)
    
    // MARK: - HTTPMethod
    
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .servers:
            return .get
        }
    }
    
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .login:
            return "/tokens"
        case .servers:
            return "/servers"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.PlaygroundServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case .login:
            break
        case .servers(let token):
            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        // Parameters
        switch self {
        case .login(let username, let password):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: ["username": username, "password": password],
                                                             options: [])
        case .servers:
            break
        }

        return urlRequest
    }
}
