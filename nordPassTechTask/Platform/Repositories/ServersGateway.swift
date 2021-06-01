//
//  ServersGateway.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 29.05.2021.
//

import Foundation
import Combine

struct ServersGateway {
    private let _token: AnyPublisher<String?, Never>
    private let _session: URLSession
    
    init(session: URLSession = .shared, getToken: AnyPublisher<String?, Never>) {
        _session = session
        _token = getToken
    }
    
    func fetchServers() -> AnyPublisher<[Server], Error> {
        return _token
            .compactMap { $0 }
            .map(_fetch)
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    private func _fetch(_ token: String) -> AnyPublisher<[Server], Error> {
        let stringUrl = "https://playground.tesonet.lt/v1/servers"
        guard let url = URL(string: stringUrl) else {
            return Fail<[Server], Error>(error: URLError(.badURL, userInfo: [NSURLErrorFailingURLErrorKey: stringUrl])).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return _session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else { throw NetworkError.unknownError }

                guard response.statusCode != 401 else { throw NetworkError.unathorized }

                guard (199...299).contains(response.statusCode) else { throw NetworkError.unknownError }

                return result.data
            }
            .decode(type: Array<Server>.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
