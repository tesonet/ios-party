import Foundation

public typealias APIServiceAuthorizationSuccess = (_ authorization: Authorization) -> ()
public typealias APIServiceServersSuccess = (_ servers: Servers) -> ()
public typealias APIServiceFailure = (Error) -> ()

public let TesonetErrorDomain = "TesonetErrorDomain"
public let TesonetDefaultErrorCode = 100
private let UsernameParamName = "username"
private let PasswordParamName = "password"
private let AuthorizationHeaderName = "Authorization"
private let AuthorizationHeaderTokenPrefix = "Bearer "
private let TesonetHost = "http://playground.tesonet.lt/v1"
private let TokensPath = "/tokens"
private let ServersPath = "/servers"

enum UrlRequestType: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPStatusCode: Int {
    case success = 200
    case unauthorized = 401
}

struct APIService {
    func authorize(username: String, password: String, success: @escaping APIServiceAuthorizationSuccess, failure: @escaping APIServiceFailure) {
        guard let url = URL(string: TesonetHost + TokensPath) else {
            failure(APIService.generalError())
            return
        }
        let userNameParam = [UsernameParamName, username].joined(separator: "=")
        let passwordParam = [PasswordParamName, password].joined(separator: "=")
        let params = [userNameParam, passwordParam].joined(separator: "&")
        let data = params.data(using: String.Encoding.utf8)
        let request = urlRequest(type: .post, url: url, body: data)
        requestAPI(request: request, success: success, failure: failure)
    }
    
    func fetchServers(success: @escaping APIServiceServersSuccess, failure: @escaping APIServiceFailure) {
        guard let url = URL(string: TesonetHost + ServersPath) else {
            failure(APIService.generalError())
            return
        }
        let request = urlRequest(type: .get, url: url)
        requestAPI(request: request, success: success, failure: failure)
    }
    
    private func requestAPI<U: Parsable>(request: NSURLRequest, success: @escaping ((U) -> ()), failure: @escaping APIServiceFailure) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    failure(APIService.generalError())
                    return
                }
                switch httpResponse.statusCode {
                case HTTPStatusCode.success.rawValue:
                    self.parseApiResults(data: data, error: error, success: success, failure: failure)
                case HTTPStatusCode.unauthorized.rawValue:
                    failure(APIService.errorWithMessage(message: LocalizationService.localized(key: "unauhorized_error_message")))
                default:
                    failure(APIService.generalError())
                }
            }
        }
        task.resume()
    }
    
    private func urlRequest(type: UrlRequestType, url: URL, body: Data? = nil) -> NSURLRequest {
        let request = NSMutableURLRequest(url: url)
        if let body = body {
            request.httpBody = body
        }
        if let token = TokenService.token() {
            request.addValue(AuthorizationHeaderTokenPrefix + token, forHTTPHeaderField: AuthorizationHeaderName)
        }
        request.httpMethod = type.rawValue
        return request
    }
    
    private func parseApiResults<U: Parsable>(data: Data?, error: Error?, success: @escaping ((U) -> ()), failure: @escaping APIServiceFailure) {
        if let error = error {
            failure(error)
        } else if let data = data, let model = U(data: data) {
            success(model)
        } else {
            failure(APIService.generalError())
        }
    }
    
    static func generalError() -> NSError {
        return errorWithMessage(message: LocalizationService.localized(key: "general_error_message"))
    }
    
    static func errorWithMessage(message: String) -> NSError {
        return NSError(
            domain: TesonetErrorDomain,
            code: TesonetDefaultErrorCode,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ]
        )
    }
}
