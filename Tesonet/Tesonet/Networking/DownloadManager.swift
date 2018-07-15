import Foundation
import Reachability

enum BackendError: Error, CustomStringConvertible {
    case urlError(reason: String)
    case noDataError(reason: String)
    case serializationError(reason: String)
    
    var description: String {
        switch self {
        case let .urlError(reason):
            return reason
        case let .noDataError(reason):
            return reason
        case let .serializationError(reason):
            return reason
        }
    }
}

// Add required response codes
enum ResponseStatusCodeError: Error, CustomStringConvertible {
    case error401(reason: String)
    case error403(reason: String)
    
    var description: String {
        switch self {
        case let .error401(reason):
            return reason
        case let .error403(reason):
            return reason
        }
    }
}

final class DownloadManager {
    
    // Singelton
    static var shared = DownloadManager()
    fileprivate init() {}
    
    //
    //
    //
    // TODO: refactor both requestToken() and requestServersData()
    //
    //
    //
    
    func requestToken(from urlString: String,
                      withParams params: [String : String],
                      completionHandler: @escaping (_ token: String?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = BackendError.urlError(reason: "Could not create URL with " + urlString)
            completionHandler(nil, error)
            return
        }

        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    let error = ResponseStatusCodeError.error401(reason: "Response: 401 Unauthorized")
                    completionHandler(nil, error)
                    return
                case 403:
                    let error = ResponseStatusCodeError.error401(reason: "Response: 403 Forbidden")
                    completionHandler(nil, error)
                    return
                default:
                    break
                }
            }
            
            // Make sure we got data
            guard let data = data else {
                let error = BackendError.noDataError(reason: "No data for URL " + urlString)
                completionHandler(nil, error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(Token.self, from: data)
                completionHandler(json.token, nil)
            } catch {
                let error = BackendError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func requestServersData(from urlString: String,
                        with token: String,
                        completionHandler: @escaping (_ jsondta: [Server]?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = BackendError.urlError(reason: "Could not create URL with " + urlString)
            completionHandler(nil, error)
            return
        }

        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    let error = ResponseStatusCodeError.error401(reason: "Response: 401 Unauthorized")
                    completionHandler(nil, error)
                    return
                case 403:
                    let error = ResponseStatusCodeError.error401(reason: "Response: 403 Forbidden")
                    completionHandler(nil, error)
                    return
                default:
                    break
                }
            }
            
            // Make sure we got data
            guard let data = data else {
                let error = BackendError.noDataError(reason: "No data for URL " + urlString)
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode([Server].self, from: data)
                completionHandler(jsonData, nil)
            } catch {
                let error = BackendError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completionHandler(nil, error)
            }
        }.resume()
    }
}
