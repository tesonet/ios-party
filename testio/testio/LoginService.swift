import Foundation
import Moya

class LoginService {
    typealias Completion = ((NetworkResult<String>) -> Void)
    
    /**
     Fetches authentication token for provided user credentials
     - parameter username: Username of a user.
     - parameter password: Password of a user
     - parameter completion: Completion block. Called after request is finished. 
     It takes NetworkResult argument that can be successful containing authentication token
     or failed with error.
      */
    
    func loginUser(username: String, password: String, completion: @escaping Completion) {
        ApiProvider.testioApi.request(.login(username: username, password: password)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200...299:
                    do {
                        let token = try response.mapString(atKeyPath: "token")
                        completion(.success(token))
                    } catch {
                        completion(.error(.unknown))
                    }
                case 401:
                    completion(.error(.unouthorized))
                default:
                    completion(.error(.unknown))
                }
            case .failure(_): completion(.error(.unknown))
            }
        }
    }
}
