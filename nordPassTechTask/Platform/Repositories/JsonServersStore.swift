//
//  ServersStore.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 29.05.2021.
//

import Foundation
import Combine

enum JsonServersStoreError: LocalizedError {
    case unknownError
    case documentDirectoryNotFound
    case encodingFailure
    case writingFailure
    
    var errorDescription: String? {
        switch self {
        case .documentDirectoryNotFound: return "Document directory not found"
        case .encodingFailure: return "Encoding failure"
        case .writingFailure: return "Writing Failure"
        case .unknownError: return "Unknown json strore error"
        }
    }
}

private let _fileName = "servers"

final class JsonServersStore {
    private let _store = PassthroughSubject<[Server], Never>()
    
    private lazy var _path: URL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(_fileName)
    }()
    
    init() {}
    
    func getServers() -> AnyPublisher<[Server], Never> {
        return Publishers.Merge(
            _load().replaceError(with: []).eraseToAnyPublisher(),
            _store.eraseToAnyPublisher()
        )
        .eraseToAnyPublisher()
    }
    
    func setServers(_ servers: [Server]) -> AnyPublisher<Void, Error> {
        return _save(servers)
    }
    
    private func _save(_ servers: [Server]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let jsonUrl = self?._path else {
                promise(.failure(JsonServersStoreError.documentDirectoryNotFound))
                return
            }

            guard let data = try? JSONEncoder().encode(servers) else {
                promise(.failure(JsonServersStoreError.encodingFailure))
                return
            }

            do {
                try data.write(to: jsonUrl)
            } catch {
                promise(.failure(JsonServersStoreError.writingFailure))
            }

            promise(.success(()))

        }
        .handleEvents(receiveOutput: { [weak self] in self?._store.send(servers) })
        .eraseToAnyPublisher()
    }

    private func _load() -> AnyPublisher<[Server], Error> {
        Future { [weak self] promise in
            guard let jsonUrl = self?._path else {
                promise(.failure(JsonServersStoreError.documentDirectoryNotFound))
                return
            }

            guard let data = try? Data(contentsOf: jsonUrl), let servers = try? JSONDecoder().decode([Server].self, from: data) else {
                promise(.success([]))
                return
            }

            promise(.success(servers))
        }
        .eraseToAnyPublisher()
    }
}
