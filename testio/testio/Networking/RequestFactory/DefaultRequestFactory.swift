
import Foundation
import Alamofire


private class DefaultRequestFactory: RequestFactory {
    
    private var sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    private let session: Session
    private let apiUrlFactory = ApiUrlFactory.shared
    
    
    // MARK: - Init
    init(session: Session) {
        self.session = session
    }
    
    
    // MARK: - RequestFactory
    func login(with username: String, password: String) -> DataRequest {
        return request(withUrl: apiUrlFactory.tokens(),
                       method: .post,
                       parameters: ["username": username,
                                    "password": password],
                       encoding: JSONEncoding.default)
    }
    
    func servers() -> DataRequest {
        return request(withUrl: apiUrlFactory.servers())
    }
    
    
    // MARK: - Private
    func request(withUrl url: URL,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {
        
        var headers: [String: String] {
            var all: [String: String] = [:]
            if let token = session.token {
                all["Authorization"] = "Bearer \(token)"
            }
            return all
        }
        
        return sessionManager.request(url,
                                      method: method,
                                      parameters: parameters,
                                      encoding: encoding,
                                      headers: headers)
    }
}


// MARK: - AppDelegate + createRequestFactory
extension AppDelegate {
    
    func createRequestFactory(session: Session) -> RequestFactory {
        return DefaultRequestFactory(session: session)
    }
}
