//
//  API.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import Foundation

func API(_ request: APIRouter, completionHandler: @escaping (Bool, Any?) -> ()) {
    let session = URLSession(configuration: URLSessionConfiguration.default);
    let task = session.dataTask(with: request.asURLRequest()) { (data, response, error) in
        if let data = data, let response = response as? HTTPURLResponse, error == nil && response.statusCode == 200 {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    completionHandler(true, json)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, nil)
                }
            }
        } else {
            DispatchQueue.main.async {
                completionHandler(false, nil)
            }
        }
    }
    task.resume()
}
