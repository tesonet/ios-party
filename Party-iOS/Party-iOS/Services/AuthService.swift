//
//  AuthService.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

final class AuthService: ServiceProtocol {
    func authenticate(username: String, password: String, completion: @escaping ServiceCompletion<Authorizable>) {
        client.authenticate(username: username, password: password, completion: completion)
    }
}
