//
//  BaseNetworkManager.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol NetworkManagerProtocol {
    var httpHandler: HTTPHandler { get set }
}

class BaseNetworkManager: NSObject, NetworkManagerProtocol {
    
    var httpHandler: HTTPHandler
    
    static var api_url: String {
        guard let url = Bundle.main.infoDictionary?["API_ENDPOINT"] as? String else {
            fatalError("Missing API_ENDPOINT setting")
        }
        
        return url
    }
    
    override init() {
        httpHandler = HTTPHandler(baseURL: BaseNetworkManager.api_url)
        super.init()
    }
    
}
