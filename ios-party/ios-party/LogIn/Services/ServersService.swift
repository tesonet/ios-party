import Foundation

public enum ServicesError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

struct ServersResponse {
    
    let servers: [ServerDescription]
}

struct ServerDescription: Codable {
    let name: String
    let distance: Int
}

final class ServersService {
    
    enum Result {
        case success(servers: ServersResponse)
        case failure(error: ServicesError)
    }
    
    typealias Completion = (Result) -> Void
    
    func getServers(token: String, completion: @escaping Completion) {
        guard let url = URL(string: "http://playground.tesonet.lt/v1/servers") else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(error: .invalidResponse))
                return
            }
            
            guard (200 ... 299).contains(statusCode) else {
                self?.finish(
                    with: completion,
                    result: .failure(error: .invalidResponse)
                )
                return
            }
            
            guard error == nil else {
                self?.finish(with: completion, result: .failure(error: .apiError))
                return
            }
            
            guard let data = data else {
                self?.finish(with: completion, result: .failure(error: .noData))
                return
            }
            
            do {
                let servicesResponse = try JSONDecoder().decode([ServerDescription].self, from: data)
                self?.finish(with: completion, result: .success(servers: ServersResponse(servers: servicesResponse)))
            } catch {
                self?.finish(with: completion, result: .failure(error: .decodeError))
            }
            }.resume()
    }
    
    private func finish(with completion: @escaping Completion, result: Result) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
