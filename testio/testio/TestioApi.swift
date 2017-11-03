import Foundation
import Moya

enum TestioApi {
    case login(username: String, password: String)
    case serverList
}

extension TestioApi: TargetType {
    var baseURL: URL { return URL(string: "http://playground.tesonet.lt/v1")! }
    
    var path: String {
        switch self {
        case .login(_, _): return "/tokens"
        case .serverList: return "/servers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .serverList:
            return .get
        case .login(_, _):
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .login(let username, let password):
            return [
                "username" : username,
                "password" : password
            ]
        default: break
        }
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch method {
        case .post: return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
    
    var task: Task { return .request }
}

extension TestioApi {

    static let endpointClosure = { (target: TestioApi) -> Endpoint<TestioApi> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        var headers = ["Content-type": "application/json"]
        
        if let token = Authentication.serviceToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return defaultEndpoint.adding(newHTTPHeaderFields: headers)
    }
}
