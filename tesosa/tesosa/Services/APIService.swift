import Foundation

public typealias APIServiceAuthorizationSuccess = (_ authorization: Authorization) -> ()
public typealias APIServiceFailure = (Error) -> ()

struct APIService {
    func fetchToken(username: String, password: String, success: APIServiceAuthorizationSuccess, failure: APIServiceFailure) {

    }
    
    private func requestAPI<U: Parsable>(url: URL, success: @escaping ((U) -> ()), failure: @escaping APIServiceFailure) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
            } else if let data = data {
                success(U(data: data))
            }
        }
        task.resume()
    }
}
