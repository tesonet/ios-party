import Foundation

enum DataError: Error, CustomStringConvertible {
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

enum HTTPError: Error, CustomStringConvertible {
    case error401(reason: String)
    // Add more status codes if required
    
    var description: String {
        switch self {
        case let .error401(reason):
            return reason
        }
    }
    
    var statusCode: String {
        switch self {
        case .error401(_):
            return "401"
        }
    }
}

final class DownloadManager {
    
    // Singelton
    static var shared = DownloadManager()
    fileprivate init() {}
    
    func loadToken(from urlString: String,
                      withParams params: [String : String],
                      completionHandler: @escaping (_ token: String?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = DataError.urlError(reason: "Could not create URL with " + urlString)
            completionHandler(nil, error)
            return
        }

        var request = URLRequest.init(url: url)
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
                    let error = HTTPError.error401(reason: "Unauthorized")
                    completionHandler(nil, error)
                    return
                default:
                    break
                }
            }
            
            // Make sure we got data
            guard let data = data else {
                let error = DataError.noDataError(reason: "No data received")
                completionHandler(nil, error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(Token.self, from: data)
                completionHandler(json.token, nil)
            } catch {
                let error = DataError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    // Here we assume that we have correct token so no need to check for 401
    func loadData(from urlString: String,
                        with token: String,
                        completionHandler: @escaping (_ jsondta: [Server]?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = DataError.urlError(reason: "Could not create URL with " + urlString)
            completionHandler(nil, error)
            return
        }

        var request = URLRequest.init(url: url)
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
            
            // Make sure we got data
            guard let data = data else {
                let error = DataError.noDataError(reason: "No data for URL received")
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode([Server].self, from: data)
                completionHandler(jsonData, nil)
            } catch {
                let error = DataError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completionHandler(nil, error)
            }
        }.resume()
    }
}
