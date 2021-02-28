//
//  ApiServiceError.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

enum ApiServiceError: Error {
    case unauthorized
    case dataNotEncoded
    case dataNotDecoded
    case dataNotLoaded
    case serverError
}
