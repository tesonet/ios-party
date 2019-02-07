//
//  DataSynchronizer.swift
//  Hwork
//
//  Created by Robertas Pauzas on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class DataSynchronizer {
    
    static let shared = DataSynchronizer()
    private init() {}
    
    func updateServers( completion: @escaping (_ error: Const.Response.ErrorStatus?)->() ) {

        if let retrievedToken = KeychainWrapper.standard.string(forKey: Const.Keychain.accessToken) {
            Api.shared.getServerList(token: retrievedToken, completion: { (serversData, errorStatus) in
               
                guard errorStatus == nil else {
                    completion(errorStatus)
                    return
                }
                
                self.deleteAllData()
                
                let success = PersistenceManager.sharedInstance.saveToCoreData(array: serversData!)
                if success {
                    completion(nil)
                } else {
                    completion(Const.Response.ErrorStatus.other)
                }
            })
        } else {
            completion(Const.Response.ErrorStatus.unauthorized)
        }
    }
    
    func deleteAllData() {
        
        PersistenceManager.sharedInstance.deleteAllData()
    }
    
}
