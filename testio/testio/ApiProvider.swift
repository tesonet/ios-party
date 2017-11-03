import Foundation
import Moya

struct ApiProvider {
    static let testioApi = MoyaProvider<TestioApi>(endpointClosure: TestioApi.endpointClosure)
}
