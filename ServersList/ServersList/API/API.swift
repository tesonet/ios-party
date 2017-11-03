//
//  API.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 16/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import Alamofire

class API {
    /**
     * * @TODO Make other requests
     * Makes post request to url
     * @param url - Request url
     * @param parameteres - Parameters list for request
     * @return DataRequest
     */
    func makeRequest(method : String, url : String, parameters : Parameters? = nil, headers: HTTPHeaders? = nil ) -> DataRequest {
        switch method {
        case "POST":
            return Alamofire.request(url, method: .post, parameters: parameters, headers: headers);
        case "GET":
            return Alamofire.request(url, method: .get, parameters: parameters, headers: headers);
        default:
            return Alamofire.request(url, method: .get, parameters: parameters, headers: headers);
        }
    }
}
