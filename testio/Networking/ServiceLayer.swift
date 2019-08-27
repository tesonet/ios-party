//
//  ServiceLayer.swift
//  testio
//
//  Created by Justinas Baronas on 17/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import Foundation


class ServiceLayer {
    
    
    class func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
       
        var componentsUrl: URL? {
            var components = URLComponents()
            components.scheme = router.scheme
            components.path = router.path
            components.host = router.host
            components.path = router.path
            return components.url
        }
    
        guard let url = componentsUrl else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        urlRequest.addValue(K.Request.ContentType.json,
                            forHTTPHeaderField: K.Request.HTTPHeaderField.contentType)
        // Token header
        let urlSessionConfig = URLSessionConfiguration.default
        if let token = Authentication.token {
            urlSessionConfig.httpAdditionalHeaders = [
                AnyHashable(K.Request.HTTPHeaderField.authorization): "Bearer " + token
            ]
        }

        // Body encoding
        if let body = try? JSONEncoder().encode(router.parameters) {
            urlRequest.httpBody = body
        }
        
        let session = URLSession(configuration: urlSessionConfig)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
        
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data, response != nil else { return }
        
            let responseObject = try! JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }
        dataTask.resume()
    }
}
