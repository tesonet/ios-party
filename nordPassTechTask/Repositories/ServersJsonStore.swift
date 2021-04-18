//
//  ServersJsonStore.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 16/04/2021.
//

import Foundation
import Combine

enum ServersJsonStoreError: LocalizedError {
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

struct ServersJsonStore: ServersStoreProtocol {
    let jsonName: String
    
    init(jsonName: String) {
        self.jsonName = jsonName
    }
    
    func save(_ servers: [ServerDTO]) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                promise(.failure(ServersJsonStoreError.documentDirectoryNotFound))
                return
            }
            let jsonUrl = documentUrl.appendingPathComponent(jsonName)
            
            guard let data = try? JSONEncoder().encode(servers) else {
                promise(.failure(ServersJsonStoreError.encodingFailure))
                return
            }
            
            do {
                try data.write(to: jsonUrl)
            } catch {
                promise(.failure(ServersJsonStoreError.writingFailure))
            }
            
            promise(.success(Void()))
            
        }
        .eraseToAnyPublisher()
    }
    
    func load() -> AnyPublisher<[ServerDTO], Error> {
        Future { promise in
            guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                promise(.failure(ServersJsonStoreError.documentDirectoryNotFound))
                return
            }
            let jsonUrl = documentUrl.appendingPathComponent(jsonName)
            
            guard let data = try? Data(contentsOf: jsonUrl), let servers = try? JSONDecoder().decode([ServerDTO].self, from: data) else {
                promise(.success([]))
                return
            }
            
            promise(.success(servers))
        }
        .eraseToAnyPublisher()
    }
}

