import Foundation
import Moya

class ServerListService {
    typealias Completion = ((NetworkResult<Servers>) -> Void)

    /**
     Fetches servers list from api.
     - parameter completion: Completion block. Called after request is finished.
     It takes NetworkResult argument that can be successful containing Servers value
     or failed with error.
     */
    
    func fetchServers(_ completion: @escaping Completion) {
        ApiProvider.testioApi.request(.serverList) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200...299:
                    do {
                        if let json = try response.mapJSON() as? [[String: Any]] {
                            completion(.success(Servers(json: json)))
                        } else {
                            completion(.error(.unknown))
                        }
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
