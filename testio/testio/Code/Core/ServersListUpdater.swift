//
//  ServersListUpdater.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import AFNetworking
import CoreData

enum ServersListUpdaterError: Error {
    case unauthorized
}

class ServersListUpdater {
    private let persistenceStore: PersistenceStore
    private let HTTPSessionManager: AFHTTPSessionManager
    
    init(persistenceStore: PersistenceStore, HTTPSessionManager: AFHTTPSessionManager) {
        self.persistenceStore = persistenceStore
        self.HTTPSessionManager = HTTPSessionManager
    }
    
    func updateServersList(with token: String, completion: @escaping (Error?) -> Void) {
        self.HTTPSessionManager.get("servers", parameters: nil, headers: ["Authorization": "Bearer " + token], progress: nil, success: { (dataTask, object) in
            guard let object = object as? Array<Dictionary<String, Any>> else {
                completion(ServersListUpdaterError.unauthorized)
                return
            }
            self.update(servers: object, completion: completion)
        }) { (dataTask, error) in
            completion(error)
        }
    }
    
    func update(servers: Array<Dictionary<String, Any>>, completion: @escaping (Error?) -> Void) {
        self.persistenceStore.performBackgroundTask { (context) in
            self.persistenceStore.resetStore(in: context)
            
            servers.forEach {
                let server = Server(context: context)
                
                if let name = $0["name"] as? String {
                    server.name = name
                }
                
                if let distance = $0["distance"] as? Double {
                    server.distance = distance
                }
            }
            
            try? context.save()
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
