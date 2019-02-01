import Reachability
import RxSwift
import RxCocoa

final class Network {
    private var isOnline: Bool  {
        if let reachability = Reachability(), reachability.connection != .none {
            return true
        }
        return false
    }
    
    func retrieveAllServers() -> Single<[Server]> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                guard let accessToken = UserSession.shared.token else {
                    return Disposables.create {}
                }

                HTTPClient.shared.loadData(from: URLs.Tesonet.dataURL, with: accessToken) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    RealmStore.shared.add(items: result)
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func retrieveToken(with params: LoginData) -> Single<String> {
        return Single.create{ [isOnline] observer in
            if !isOnline {
                return Disposables.create {}
            } else {
                HTTPClient.shared
                    .loadToken(from: URLs.Tesonet.tokenURL,
                               withParams: params.toJson()) { result, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let result = result else {
                        observer(.error(DataError.unknownError))
                        return
                    }
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
}
