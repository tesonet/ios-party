//
//  LoginRepositoryProtocol.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

protocol LoginRepositoryProtocol {
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error>
}
