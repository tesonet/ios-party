import Foundation

public enum LoginError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case encodeError
    case notAuthorized
}

final class LoginService {
    
    enum Result {
        case success(token: String)
        case failure(error: LoginError)
    }
    
    typealias Completion = (Result) -> Void
    
    func getToken(credentials: Credentials, completion: @escaping Completion) {
        guard let url = URL(string: "http://playground.tesonet.lt/v1/tokens") else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(credentials)
        } catch _ {
            completion(.failure(error: .encodeError))
        }
        
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(error: .invalidResponse))
                return
            }
            
            guard (200 ... 299).contains(statusCode) else {
                self?.finish(
                    with: completion,
                    result: .failure(error: statusCode == 401 ? .notAuthorized : .invalidResponse)
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
                let token = try JSONDecoder().decode(AuthorizationResponse.self, from: data)
                self?.finish(with: completion, result: .success(token: token.token))
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
