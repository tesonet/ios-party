
import Foundation
import PromiseKit


class AuthService {
    
    private let sessionContext: SessionContext
    
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func login(with username: String,
               password: String) -> Promise<AuthResponse> {
        return Promise { seal in
            sessionContext.requestFactory.login(with: username,
                                                password: password)
                .validate()
                .responseJsonData(seal: seal) { jsonData in
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AuthResponse.self, from: jsonData)
                    return response
            }
        }
    }
}
