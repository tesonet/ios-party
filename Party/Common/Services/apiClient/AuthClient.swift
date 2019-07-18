import UIKit
import Alamofire

class AuthClient {
    
    enum Result {
        case success(token: AuthToken)
        case failure(Error)
    }
    
    // MARK: - Dependancies
    
    private var sessionManager: Alamofire.SessionManager
    
    // MARK: - State
    
    /// The base url of the authentication server.
    var baseUrl: URL
    
    // MARK: Init
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
        self.sessionManager = Alamofire.SessionManager.default
    }
    
    // MARK: Authentication
    
    /// A method for authentication with provided username and password.
    ///
    /// - Parameters:
    ///   - username: A username value to authenticate user.
    ///   - password: A password value to authenticate user
    ///   - completion: A result block after authentication process.
    func authenticate(with username: String, password: String, completion: @escaping (_ result: Result) -> Void) {
        let resource = AuthToken.get(username: username, password: password)
        let url = baseUrl.appendingPathComponent(resource.endpoint.path())
        
        var acceptedStatusCodes: [Int] = Array(200..<300)
        acceptedStatusCodes += [400, 500]
        
        // Performe a request.
        sessionManager.request(url,
                               method: resource.method,
                               parameters: resource.parameters)
            .validate(statusCode: acceptedStatusCodes)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                let result: Result
                
                switch response.result {
                case .success:
                    do {
                        if let token = try response.data.flatMap(resource.parse) {
                            result = .success(token: token)
                        } else {
                            result = .failure(AppError.unknown)
                        }
                    } catch let error {
                        result = .failure(error)
                    }
                case .failure(let error):
                    result = .failure(error)
                }
                completion(result)
        }
    }
}
