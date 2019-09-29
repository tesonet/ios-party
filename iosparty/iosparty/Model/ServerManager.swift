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
        do{
            try updateServerList {
                onComplete(RealmPersistentStorage.getServerList())
            }
        }catch{
            onComplete(RealmPersistentStorage.getServerList())
        }
    }
    
    static func updateServerList(onComplete: @escaping () -> ()) throws{
        let apiHandler = APIHandler()
        try apiHandler.getServers(token: CredentialManager.getUserToken()) { (servers, isAuthorized)  in
            if isAuthorized{
                RealmPersistentStorage.updateServerList(list: servers)
            }
            onComplete()
        }
    }
    
    static func deleteServers(){
        RealmPersistentStorage.deleteServerList()
    }
}
