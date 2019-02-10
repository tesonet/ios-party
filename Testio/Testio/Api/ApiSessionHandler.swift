//
//  ApiSessionHandler.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

class ApiSessionHandler: RequestAdapter, RequestRetrier {
    static let sharedInstance = ApiSessionHandler()
    public let keychain = Keychain(service: AppConfig.KeychainSettings.service)
    public var isLoggedIn: Bool {
        return getToken() != nil
    }
    private var _token: String?
    private var isRefreshing: Bool = false
    private let lock = NSLock()
    private var requestsToRetry: [RequestRetryCompletion] = []
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    func set(authToken token: String?) {
        _token = token
        keychain[AppConfig.KeychainSettings.authorizationToken] = _token
        
        if _token == nil {
            NotificationCenter.default.post(name: Notification.Name.UserLoggedOut, object: nil)
        }
    }
    
    private func getToken() -> String? {
        if _token == nil {
            _token = keychain[AppConfig.KeychainSettings.authorizationToken]
        }
        return _token
    }
    
    public func logout() {
        set(authToken: nil)
    }
    
    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let token = getToken() else {
            return urlRequest
        }
        let headerValue = String(format: HttpHeaderName.Authorization.BearerToken, token)
        urlRequest.setValue(headerValue, forHTTPHeaderField: HttpHeaderName.Authorization.name)
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse {
            switch response.statusCode {
            case 400:
                completion(true, 0.1)
            case 401:
                logout()
                completion(false, 0)
            default:
                completion(false, 0.0)
            }
        }
    }
}
