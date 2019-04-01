// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper
import Domain

extension ObservableType where E == DataRequest {
    func validateJSONResponse() -> Observable<[String: Any]> {
        return responseData()
            .flatMap({  (arguments) -> Observable<[String: Any]>  in
                let (response, data) = arguments
                if let error = self.validateResponseStatusCode(response.statusCode) {
                    return .error(error)
                }
                guard !data.isEmpty else {
                    return .error(NetworkError.emptyBody)
                }
                guard let json = try? JSONSerialization.jsonObject(
                        with: data,
                        options: []) as Any,
                    let jsonObject = json as? [String: Any] else {
                        return .error(NetworkError.unserializableBody)
                }

                return .just(jsonObject)
            })
    }
    
    // MARK: - Helpers
    private func validateResponseStatusCode(_ statusCode: Int) -> Error? {
        switch statusCode {
        case 200..<300:
            return nil
        case 401:
            return NetworkError.unauthorized
        default:
            return NetworkError.unacceptableStatusCode(statusCode)
        }
    }
}
