//
//  SecureStorageServiceProtocol.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol SecureStorageServiceProtocol: class {
    var authToken: String? { get set }
}
