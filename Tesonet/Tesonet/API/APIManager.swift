//
//  APIManager.swift
//  Tesonet
//

import Alamofire
import SwiftyJSON

protocol APIProtocol {
    func requestType() -> HTTPMethod
    func endpoint() -> String
    func params() -> [String: Any]?
    func headers() -> [String: String]
}

private let baseUrl: String = "http://playground.tesonet.lt/v1/"

class APIManager {

    static func sendRequest(_ request: APIProtocol, onSuccess: @escaping (JSON) -> Void, onError: ((Int?) -> Void)? = nil) {
        let requestUrl = baseUrl + request.endpoint()
        AF.request(requestUrl, method: request.requestType(), parameters: request.params(), encoding: JSONEncoding.default, headers: HTTPHeaders(request.headers())).responseJSON { (response) in
            if let result = response.value, response.response?.statusCode != 401 {
                onSuccess(JSON(result))
            } else {
                onError?(response.response?.statusCode)
            }
        }
    }
}
