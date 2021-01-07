
import Foundation
import PromiseKit


class AuthService {
    
    private let sessionContext: SessionContext
    
    
    // MARK: - Init
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    
    // MARK: - Public
    func login(with username: String,
               password: String) -> Promise<AuthResponse> {
        return Promise { seal in
            sessionContext.requestFactory.login(with: username,
                                                password: password)
                .validate()
                .responseJsonData(seal: seal) { jsonData in
                    
                    let response = try TestioJSONDecoder.decoder.decode(AuthResponse.self,
                                                                        from: jsonData)
                    return response
            }
        }
    }
}
