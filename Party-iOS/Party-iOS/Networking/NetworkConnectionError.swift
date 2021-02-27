//
//  NetworkConnectionError.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

public enum NetworkConnectionError: Error {
    case unknown
    case url(URLError)
    case http(HTTPStatusCode?, Data?)
}
