import Foundation

final class DownloadManager {
    
    // Singelton
    static var shared = DownloadManager()
    fileprivate init() {}
    
    /**
     Obtain token.
     
     - parameter from:       token url string.
     - parameter params:     json for URLRequest httpBody.
     - parameter completion: The block that should be called. It is passed either received token or error.
     */
    func loadToken(from urlString: String,
                   withParams params: [String : String],
                   completion: @escaping (_ token: String?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = DataError.urlError(reason: "Could not create URL with " + urlString)
            completion(nil, error)
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
                completion(nil, error)
                return
            }
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    let error = HTTPError.error401(reason: "Unauthorized")
                    completion(nil, error)
                    return
                default:
                    break
                }
            }
            
            // Make sure we got data
            guard let data = data else {
                let error = DataError.noDataError(reason: "No data received")
                completion(nil, error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(Token.self, from: data)
                completion(json.token, nil)
            } catch {
                let error = DataError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completion(nil, error)
            }
        }.resume()
    }
    
    /**
     Obtain data.
     
     - note: We are loged in, so we have correct access token. Since no refresh token required - access token does not expire.
     Hence - no 401. In real service access token would expire.
     
     - parameter from:       data url string.
     - parameter token:      Bearer authorization token.
     - parameter completion: The block that should be called. It is passed either received data or error.
     */
    
    /**
     Obtain data.
     
     - parameter We assume that we have correct token so no 401.
     
     - parameter from:       data url string.
     - parameter token:      Bearer authorization token.
     - parameter completion: The block that should be called. It is passed either received data or error.
     */
    func loadData(from urlString: String,
                  with token: String,
                  completion: @escaping (_ jsondta: [Server]?, _ error: Error?) -> ()) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            let error = DataError.urlError(reason: "Could not create URL with " + urlString)
            completion(nil, error)
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
                completion(nil, error)
                return
            }
            
            // Make sure we got data
            guard let data = data else {
                let error = DataError.noDataError(reason: "No data for URL received")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode([Server].self, from: data)
                completion(jsonData, nil)
            } catch {
                let error = DataError.serializationError(reason: "Serialization error for data from URL " + urlString)
                completion(nil, error)
            }
        }.resume()
    }
}
