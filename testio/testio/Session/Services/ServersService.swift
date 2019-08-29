
import Foundation
import PromiseKit


class ServersService {
    
    private let sessionContext: SessionContext
    
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func servers() -> Promise<[Server]> {
        return Promise { seal in
            sessionContext.requestFactory.servers()
                .validate()
                .responseJsonData(seal: seal) { jsonData in
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([Server].self, from: jsonData)
                    return response
            }
        }
    }
}
