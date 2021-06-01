//
//  ServersStore.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 29.05.2021.
//

import Combine

struct ServersRepository {
    private let _fetchServers: () -> AnyPublisher<[Server], Error>
    private let _getServers: () -> AnyPublisher<[Server], Never>
    private let _setServers: ([Server]) -> AnyPublisher<Void, Error>
    
    init(
        fetchServers: @escaping () -> AnyPublisher<[Server], Error>,
        getServers: @escaping () -> AnyPublisher<[Server], Never>,
        setServers: @escaping ([Server]) -> AnyPublisher<Void, Error>
    ) {
        _fetchServers = fetchServers
        _getServers = getServers
        _setServers = setServers
    }
    
    func servers() -> AnyPublisher<[Server], Never> {
        return _getServers()
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func syncServers() -> AnyPublisher<(), Error> {
        return _fetchServers()
            .flatMap(_setServers)
            .eraseToAnyPublisher()
    }
}
