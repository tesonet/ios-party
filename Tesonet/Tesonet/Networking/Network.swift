import Foundation
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
    
    func retrieveAll() -> Single<[Server]> {
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
                        observer(.error(DataError.unknownError(reason: "Something went wrong.")))
                        return
                    }
                    RealmStore.shared.add(items: result)
                    observer(.success(result))
                }
            }
            
            return Disposables.create {}
        }
    }
}
