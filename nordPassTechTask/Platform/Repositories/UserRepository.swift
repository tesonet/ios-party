//
//  ServersStore.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 29.05.2021.
//

import Combine

struct UserRepository {
    private let _store = CurrentValueSubject<User?, Never>(nil)
    private let _authenticate: (String, String) -> AnyPublisher<User, Error>
    
    init(authenticate: @escaping (String, String) -> AnyPublisher<User, Error>) {
        _authenticate = authenticate
    }
    
    func user() -> AnyPublisher<User?, Never> {
        return _store.eraseToAnyPublisher()
    }

    func login(username: String, password: String) -> AnyPublisher<(), Error> {
        return _authenticate(username, password)
            .handleEvents(receiveOutput: _store.send)
            .handleEvents(receiveOutput: { _ in
                if let passwordData = password.data(using: .utf8) {
                    Keychain.save(password: passwordData, account: username)
                }
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        _store.send(nil)
    }
}
