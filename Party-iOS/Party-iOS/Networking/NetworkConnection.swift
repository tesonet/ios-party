//
//  NetworkConnection.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

public struct NetworkConnection {
    let session: URLSessionProtocol
    let additionalHeaders: Headers?
    
    public init(session: URLSessionProtocol = URLSession.shared, additionalHeaders: Headers?) {
        self.session = session
        self.additionalHeaders = additionalHeaders
    }
    
    public typealias ConnectionResult = Result<(URLResponse, Data), ConnectionError>
    public typealias Completion = (ConnectionResult) -> Void
    
    public func request(_ endPoint: EndPoint, completion: @escaping Completion) {
        let request = RequestFactory().makeRequest(endpoint: endPoint, additionalHeaders: additionalHeaders)
        session.dataTask(with: request) { (result) in
            DispatchQueue.main.async {
                self.handleTaskResult(result, completion: completion)
            }
        }.resume()
    }
        
    private func handleTaskResult(_ result: DataTaskResult, completion: @escaping Completion) {
        switch result {
        case .success(let success):
            guard let response = success.0 as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            let responseResult: ConnectionResult = {
                switch response.status?.responseType {
                 case .success: return .success(success)
                 default: return .failure(.http(response.status, success.1))
                 }
            }()
            completion(responseResult)
        case .failure(let failure):
            guard let failure = failure as? URLError else { completion(.failure(.unknown)); return }
            completion(.failure(.url(failure)))
        }
    }
}
