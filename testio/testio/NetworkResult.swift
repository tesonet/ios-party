import Foundation
import Moya

enum ServiceError: Swift.Error {
    case unouthorized
    case unknown
}

enum NetworkResult<T> {
    case success(T)
    case error(ServiceError)
}
