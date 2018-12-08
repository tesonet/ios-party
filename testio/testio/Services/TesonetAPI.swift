//
//  TesonetAPI.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 04/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import Moya

enum TesonetAPI {
    
    case login(_ request: LoginRequest)
    case getServers
}

extension TesonetAPI: TargetType {
    
    var headers: [String : String]? {
        if let authToken = User.auth?.token {
            return ["Authorization": authToken]
        }
        
        return nil
    }
    
    var baseURL: URL {
        return URL(string: Const.tesonetAPIBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .login: return "/tokens"
        case .getServers: return "/servers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getServers:
            return .get
        case .login:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self.method {
        case .delete,
             .get,
             .head,
             .options:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        var jsonStr: String = ""
        switch self {
        case .login:
            jsonStr = """
            {"token": "f9731b590611a5a9377fbd02f247fcdf"}
            """
        case .getServers:
            jsonStr = """
            [
            {
            "name": "Singapore #59",
            "distance": 412
            },
            {
            "name": "United Kingdom #47",
            "distance": 1367
            },
            {
            "name": "Japan #68",
            "distance": 64
            },
            {
            "name": "Japan #35",
            "distance": 465
            },
            {
            "name": "Latvia #35",
            "distance": 185
            },
            {
            "name": "Japan #80",
            "distance": 1549
            },
            {
            "name": "Latvia #44",
            "distance": 1188
            },
            {
            "name": "United States #37",
            "distance": 1005
            },
            {
            "name": "Japan #28",
            "distance": 232
            },
            {
            "name": "United Kingdom #89",
            "distance": 950
            },
            {
            "name": "Latvia #88",
            "distance": 528
            },
            {
            "name": "United Kingdom #40",
            "distance": 1906
            },
            {
            "name": "Singapore #33",
            "distance": 321
            },
            {
            "name": "United Kingdom #98",
            "distance": 1644
            },
            {
            "name": "Singapore #93",
            "distance": 395
            },
            {
            "name": "United States #84",
            "distance": 591
            },
            {
            "name": "Latvia #48",
            "distance": 193
            },
            {
            "name": "Latvia #94",
            "distance": 1032
            },
            {
            "name": "United Kingdom #37",
            "distance": 1623
            },
            {
            "name": "Singapore #51",
            "distance": 536
            },
            {
            "name": "United States #59",
            "distance": 295
            },
            {
            "name": "Lithuania #84",
            "distance": 536
            },
            {
            "name": "United States #22",
            "distance": 343
            },
            {
            "name": "Japan #23",
            "distance": 1801
            },
            {
            "name": "Germany #99",
            "distance": 1722
            },
            {
            "name": "Japan #98",
            "distance": 75
            },
            {
            "name": "Lithuania #63",
            "distance": 957
            },
            {
            "name": "Japan #34",
            "distance": 369
            },
            {
            "name": "Singapore #90",
            "distance": 273
            },
            {
            "name": "Lithuania #49",
            "distance": 326
            }
            ]
            """
        default:
            jsonStr = ""
        }
        return jsonStr.data(using: String.Encoding.utf8)!
    }
}

fileprivate var pluginsForEnvironment: [PluginType] = {
    var plugins: [PluginType] = [
        NetworkActivityPlugin(),
        UserAuthenticationPlugin()
    ]
    
    if Const.environment == .development {
        plugins.append(NetworkLoggerPlugin(verbose: true))
    }
    
    return plugins
}()

let TesonetAPIProvider = MoyaProvider<TesonetAPI>(stubClosure: MoyaProvider.neverStub, plugins: pluginsForEnvironment)
