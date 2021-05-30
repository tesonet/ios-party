//
//  ServersEnvironment.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import Combine
import ComposableArchitecture

struct ServersEnvironment {
    let fetchServers: () -> Effect<(), Error>
    let getServers: () -> Effect<[Server], Never>
}

extension ServersEnvironment {
    init(_ globalDependencies: GlobalDependencies) {
        self.fetchServers = {
            globalDependencies.serversRepository.syncServers()
                .eraseToEffect()
        }
        self.getServers = {
            globalDependencies.serversRepository.servers()
                .eraseToEffect()
        }
    }
}
