import Reachability
import RxSwift
import Alamofire

final class Network {
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    /**
     Obtain servers.
     
     - returns: Single observable with array of server objects.
     */
    func retrieveAllServers() -> Single<[Server]> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                guard let accessToken = UserSession.shared.token else {
                    return Disposables.create {}
                }
                
                let request = AF.request(Router.servers(token: accessToken))
                    .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<[Server]>) in
                        switch response.result {
                        case .success:
                            guard let items = response.result.value else {
                                return
                            }
                            
                            if let servers = response.result.value {
                                RealmStore.shared.add(items: servers)
                            }
                            
                            observer(.success(items))
                        case .failure(let error):
                            // 401 could be handled here using response.response?.statusCode
                            // but it would be a bit artificial because token is always present at this point
                            
                            debugPrint(error.localizedDescription)
                            let noDataError = DataError.noDataError
                            observer(.error(noDataError))
                        }
                };
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    /**
     Obtain token.
     
     - parameter params: structure holding login data - username and password.
     - returns: Single observable with token.
     */
    func retrieveToken(with params: LoginData) -> Single<String> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                let request = AF.request(Router.login(username: params.username, password: params.password))
                    .responseDecodable (decoder: JSONDecoder()) { (response: DataResponse<Token>) in
                        switch response.result {
                        case .success:
                            guard let token = response.result.value?.token else {
                                return
                            }
                            observer(.success(token))
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                            let tokenError = DataError.tokenError
                            observer(.error(tokenError))
                        }
                };
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
}
