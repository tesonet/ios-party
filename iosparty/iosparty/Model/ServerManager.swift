//
//  ServerManager.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import RealmSwift

class ServerManager{
    
    static func getServers(onComplete: @escaping (Results<Server>) -> ()){
        onComplete(RealmPersistentStorage.getServerList())
    }
    
    static func updateServerList(onComplete: @escaping () -> ()){
        let apiHandler = APIHandler()
        apiHandler.getServers(token: "f9731b590611a5a9377fbd02f247fcdf") { (servers) in
            RealmPersistentStorage.updateServerList(list: servers)
            onComplete()
        }
    }
}
