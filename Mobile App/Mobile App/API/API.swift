//
//  API.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import Moya

enum API {
    enum Authorization {}
    enum Servers {}
    enum Headers {}
    
    static var baseURL: URL {
        return URL(string: "http://playground.tesonet.lt/v1")!
    }
}
