import Foundation

final class HTTPClient {
    typealias TokenClosure = (_ token: String?, _ error: Error?) -> ()
    typealias DataClosure = (_ jsondta: [Server]?, _ error: Error?) -> ()
    
    /**
     Obtain token.
     
     - parameter from:       token url string.
     - parameter params:     json for URLRequest httpBody.
     - parameter completion: The block that should be called. It is passed either received token or error.
     */
    func loadToken(from urlString: String,
                   withParams params: [String : String],
                   then completion: @escaping TokenClosure) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(nil, DataError.urlError(url: urlString))
            return
        }

        var request = URLRequestCreator.request(method: .POST, url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            // Check for genaral error
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Make sure we got data
            guard let data = data else {
                completion(nil, DataError.noDataError)
                return
            }

            let decoder = JSONDecoder()
            do {
                let tokenData = try decoder.decode(Token.self, from: data)
                completion(tokenData.token, nil)
            } catch {
                completion(nil, DataError.serializationError(reason: "crudentials"))
            }
        }.resume()
    }
    
    /**
     Obtain servers.
     
     - note: We are loged in, so we have correct access token.
     Since no refresh token required - access token does not expire. Hence - no 401.
     In real service access token would expire.
     
     - parameter from:       data url string.
     - parameter token:      Bearer authorization token.
     - parameter completion: The block that should be called. It is passed either received data or error.
     */
    func loadData(from urlString: String,
                  with token: String,
                  then completion: @escaping DataClosure) {
        // Check if URL can be created
        guard let url = URL(string: urlString) else {
            completion(nil, DataError.urlError(url: urlString))
            return
        }

        var request = URLRequestCreator.request(method: .GET, url: url)
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
                completion(nil, DataError.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let serversData = try decoder.decode([Server].self, from: data)
                completion(serversData, nil)
            } catch {
                completion(nil, DataError.serializationError(reason: "servers data"))
            }
        }.resume()
    }
}
