//
//  ServersRepositories.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 14/04/2021.
//

import Foundation
import Combine

struct ServersRepository: ServersRepositoryProtocol {
    private let session: URLSession
    private let appState: AppState
    
    init(session: URLSession = .shared, appState: AppState) {
        self.session = session
        self.appState = appState
    }
    
    func getServers() -> AnyPublisher<[ServerDTO], Error> {
        let stringUrl = "https://playground.tesonet.lt/v1/servers"
        guard let url = URL(string: stringUrl) else {
            return Fail<[ServerDTO], Error>(error: URLError(.badURL, userInfo: [NSURLErrorFailingURLErrorKey: stringUrl])).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(appState.token ?? "" )", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else { throw NetworkError.unknownError }
                
                guard response.statusCode != 401 else { throw NetworkError.unathorized }
                
                guard (199...299).contains(response.statusCode) else { throw NetworkError.unknownError }
                
                return result.data
            }
            .decode(type: ServersResponse.self, decoder: JSONDecoder())
            .map(\.servers)
            .eraseToAnyPublisher()
    }
}
