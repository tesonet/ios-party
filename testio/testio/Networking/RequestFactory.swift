
import Foundation
import Alamofire


protocol RequestFactory {
    
    func login(with username: String, password: String) -> DataRequest
}


extension AppDelegate {
    
    func createRequestFactory(session: Session) -> RequestFactory {
        return DefaultRequestFactory(session: session)
    }
}


private class DefaultRequestFactory: RequestFactory {
    
    private var sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func login(with username: String, password: String) -> DataRequest {
        return request(withUrl: APIUrls.shared.tokens(),
                       method: .post,
                       parameters: ["username": username,
                                    "password": password],
                       encoding: JSONEncoding.default)
    }
}


private extension DefaultRequestFactory {
    
    private func request(withUrl url: URL,
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
