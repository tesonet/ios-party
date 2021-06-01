//
//  GlobalEnvironment.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 30.05.2021.
//

import Combine
import CombineSchedulers

struct GlobalDependencies {
    let userRepository: UserRepository
    let serversRepository: ServersRepository
}

typealias GlobalEnvironment<Environment> = SystemEnvironment<Environment, GlobalDependencies>

extension GlobalDependencies {
    static let live: GlobalDependencies = {
        let authGateway = AuthGateway()
        let userRepository = UserRepository(authenticate: authGateway.authenticate)
        let serversGateway = ServersGateway(
            getToken: userRepository.user()
                .map(\.?.token)
                .eraseToAnyPublisher()
        )
        let serversStore = JsonServersStore()
        let serversRepository = ServersRepository(
            fetchServers: serversGateway.fetchServers,
            getServers: serversStore.getServers,
            setServers: serversStore.setServers
        )
        return GlobalDependencies(userRepository: userRepository, serversRepository: serversRepository)
    }()
}

#if DEBUG
extension GlobalDependencies {
    static let mock: GlobalDependencies = {
        let userRepository = UserRepository(
            authenticate: { _, _ in
                Deferred {
                    Future<User, Error> { $0(.success(User(token: ""))) }
                }
                .eraseToAnyPublisher()
            }
        )
        let serversRepository = ServersRepository(
            fetchServers: {
                Just<[Server]>([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            getServers: {
                Just(Server.mockList)
                    .eraseToAnyPublisher()
            },
            setServers: { _ in
                Deferred {
                    Future<Void, Error> { $0(.success(())) }
                }
                .eraseToAnyPublisher()
            }
        )
        return GlobalDependencies(userRepository: userRepository, serversRepository: serversRepository)
    }()
}
#endif
