//
//  ServerListOperation.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation
import Alamofire

class ServerListOperation {
    
    // MARK: - Constants
    struct Constants {
        static let backendURL = "https://playground.tesonet.lt/v1/servers"
    }
    
    // MARK: - Dependencies
    private let authorizationRepository = AuthorizationRepository.shared
    
    // MARK: - Methods
    func request() -> DataRequest? {
        guard let token = authorizationRepository.token() else {
            print("count not found authorization token!")
            return nil
        }
        
        return AF.request(Constants.backendURL,
                          method: .get,
                          headers: ["Authorization": "Bearer \(token)"])
            .validate(statusCode: 200..<300)
    }
    
    func parseServerList(response: Any) -> [ServerListEntity]? {
        guard let dictList = response as? [[String: Any]] else {
            return nil
        }
        
        return ServerListEntity.listFrom(dictList: dictList)
    }
}
