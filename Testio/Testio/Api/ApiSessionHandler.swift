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
//    private var _refreshToken: String?
    private var isRefreshing: Bool = false
    private let lock = NSLock()
    private var requestsToRetry: [RequestRetryCompletion] = []
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    func set(authToken token: String?, withRefreshToken refreshToken: String?) {
        _token = token
//        _refreshToken = refreshToken
        keychain[AppConfig.KeychainSettings.authorizationToken] = _token
//        keychain[KeychainSettings.refreshUserToken] = _refreshToken
        
//        if _token != nil {
//            NotificationCenter.default.post(name: Notification.UserLoggedIn, object: nil)
//        } else if _token == nil && _refreshToken == nil {
//            NotificationCenter.default.post(name: Notification.UserLoggedOut, object: nil)
//        }
    }
    
    func set(authToken token: String?) {
        _token = token
        keychain[AppConfig.KeychainSettings.authorizationToken] = _token
        
//        if _token != nil {
//            NotificationCenter.default.post(name: Notification.UserLoggedIn, object: nil)
//        }
    }
    
    private func getToken() -> String? {
        if _token == nil {
            _token = keychain[AppConfig.KeychainSettings.authorizationToken]
        }
        return _token
    }
    
//    func getRefreshToken() -> String? {
//        if _refreshToken == nil {
//            _refreshToken = keychain[KeychainSettings.refreshUserToken]
//        }
//        return _refreshToken
//    }
    
    public func logout() {
        set(authToken: nil, withRefreshToken: nil)
    }
    
    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let token = getToken() else {
            return urlRequest
        }
        urlRequest.setValue(String(format: HttpHeaderName.Authorization.BearerToken, token), forHTTPHeaderField: HttpHeaderName.Authorization.name)
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
//                requestsToRetry.append(completion)
//                if !isRefreshing {
//                    refreshTokens { [weak self] (succeeded, accessToken, refreshToken) in
//                        guard let strongSelf = self else {
//                            return
//                        }
//                        guard succeeded else {
//                            strongSelf.logout()
//                            return
//                        }
//
//                        strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
//                        strongSelf.set(authToken: accessToken, withRefreshToken: refreshToken)
//                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
//                        strongSelf.requestsToRetry.removeAll()
//                    }
//                }
            default:
                completion(false, 0.0)
            }
        }
    }
    
//    // MARK: - Refresh Tokens
//    private func refreshTokens(completion: @escaping RefreshCompletion) {
//        guard !isRefreshing else { return }
//        guard let refreshToken = getRefreshToken() else {
//            completion(false, nil, nil)
//            return
//        }
//        set(authToken: nil)
//        isRefreshing = true
//        authService.refreshAuthenticationToken(refreshToken) { [weak self] (response) in
//            guard let strongSelf = self else { return }
//            guard let accessToken = response.token, let refreshToken = response.refreshToken else {
//                completion(false, nil, nil)
//                return
//            }
//
//            completion(true, accessToken, refreshToken)
//            strongSelf.isRefreshing = false
//        }
//    }
}
