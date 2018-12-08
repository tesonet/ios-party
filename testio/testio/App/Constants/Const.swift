//
//  Const.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 07/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

enum Environment {
    case development
    case staging
    case production
}

enum Const {
    static let tesonetAPIBaseUrl = "http://playground.tesonet.lt/v1"
    
    static let standardAnimationDuration: TimeInterval = 0.2
    
}

// MARK: - Environment

extension Const {
    
    #if ENV_PROD // currently unused (needs separate build target)
    static let environment = Environment.production
    #elseif ENV_STAGING // currently unused (needs separate build target)
    static let environment = Environment.staging
    #else
    static let environment = Environment.development
    #endif
}
