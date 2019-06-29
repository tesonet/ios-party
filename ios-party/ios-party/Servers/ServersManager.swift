import Foundation

enum GetServersResult {
    case success(serverResponse: ServersResponse)
    case failure
}

final class ServersManager {
    
    private let serversService = ServersService()
    private let serversStore = ServersStore()
    
    func getServers(with token: String, completion: @escaping (GetServersResult) -> Void) {
        loadServersFromStorage { [weak self] result in
            guard let result = result else {
                self?.loadServersFromNetwork(with: token) { [weak self] loadResult in
                    guard let result = loadResult else {
                        completion(.failure)
                        return
                    }
                    
                    self?.serversStore.saveServers(serversResponse: result)
                    completion(.success(serverResponse: result))
                }
                return
            }
            
            completion(.success(serverResponse: result))
        }
    }
    
    private func loadServersFromStorage(completion: @escaping (ServersResponse?) -> Void) {
        serversStore.loadServers { result in
            switch result {
            case .success(let serverResponse):
                completion(serverResponse)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func loadServersFromNetwork(with token: String, completion: @escaping (ServersResponse?) -> Void) {
        serversService.getServers(token: token) { result in
            switch result {
            case .success(let serverList):
                completion(serverList)
            case .failure:
                completion(nil)
            }
        }
    }
}
