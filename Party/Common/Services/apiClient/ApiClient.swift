//
//  ApiClient.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let unauthorizedAccess = Notification.Name("UnauthorizedAccess")
}

class ApiClient {
    
    // MARK: - Dependancies
    
    private var sessionManager: Alamofire.SessionManager
    
    // MARK: - States
    
    // A reference for global access to a shared ApiClient instance.
    static var shared: ApiClient!
    
    /// The base URL of the backend API server.
    let baseUrl: URL
    
    // MARK: Init
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
        self.sessionManager = Alamofire.SessionManager.default
    }
    
    // MARK: Resource loading
    
    func load<T>(_ resource: Resource<T>,
                 success: @escaping (_ result: T?) -> Void,
                 failure: @escaping (_ error: Error) -> Void) {
        let url = baseUrl.appendingPathComponent(resource.endpoint.path())
        
        var acceptedStatusCodes: [Int] = Array(200..<300)
        acceptedStatusCodes += [400, 500]
        
        // Performe a request.
        sessionManager.request(url,
                               method: resource.method,
                               parameters: resource.parameters)
            .validate(statusCode: acceptedStatusCodes)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    do {
                        let result = try response.data.flatMap(resource.parse)
                        success(result)
                    } catch let error {
                        failure(error)
                    }
                case .failure(let error):
                    if let afError = error as? AFError,
                        afError.responseCode == 401 {
                        NotificationCenter.default.post(name: .unauthorizedAccess, object: nil)
                    }
                    failure(error)
                }
        }
    }
}
