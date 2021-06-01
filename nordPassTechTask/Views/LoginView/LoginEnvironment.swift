//
//  LoginEnvironment.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import Combine
import ComposableArchitecture

struct LoginEnvironment {
    let login: (String, String) -> Effect<Void, Error>
    let logout: () -> ()
}

extension LoginEnvironment {
    init(_ globalDependencies: GlobalDependencies) {
        self.login = { username, password in
            globalDependencies.userRepository.login(username: username, password: password)
                .eraseToEffect()
        }
        
        self.logout = globalDependencies.userRepository.logout
    }
}
