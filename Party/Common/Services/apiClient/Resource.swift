//
//  Resource.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation
import Alamofire

struct Resource<ResultType> {
    
    // MARK: - States
    
    /// An endpoint to make a call to.
    var endpoint: Endpoint
    
    /// The http request method
    var method: HTTPMethod
    
    /// A request parameters.
    var parameters: [String: Any]?
    
    /// A data parser for given result type.
    var parse: (Data) throws -> ResultType?
    
    // MARK: - Init
    
    init(endpoint: Endpoint,
         method: HTTPMethod,
         parameters: [String: Any]? = nil,
         parse: @escaping (Data) throws -> ResultType?) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.parse = parse
    }
}

//Convenience constructors for Resources that download JSON's and parses them to entities.
extension Resource where ResultType: Decodable {
    
    /// Resource for loading entities.
    static func entity(_ endpoint: Endpoint,
                       method: HTTPMethod,
                       parameters: [String: Any]? = nil) -> Resource<ResultType> {
        return Resource<ResultType>(endpoint: endpoint,
                                    method: method,
                                    parameters: parameters,
                                    parse: { data in
                                        do {
                                            let decoder = JSONDecoder()
                                            let entity = try decoder.decode(ResultType.self, from: data)
                                            return entity
                                        } catch let error {
                                            throw error
                                        }
        })
    }
}
