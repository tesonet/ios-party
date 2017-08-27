//
//  MainViewModel.swift
//  ios-party
//
//  Created by Adomas on 27/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import Foundation

struct Server {
    
    let name: String
    let distance: Int
    
    init(fromDictionary dictionary: NSDictionary) {
        self.name = dictionary.value(forKey: "name") as? String ?? ""
        self.distance = dictionary.value(forKey: "distance") as? Int ?? 0
    }
}

class ServerListModel {
    
    private let request = Request()
    private let serversListPath = "servers"
    
    //var servers: [Server] = []
    
    func getServerList(completion: @escaping ([Server], Error?) -> Void) {
        request.dataTask(withPath: serversListPath) { object, error in
            var servers: [Server] = []
            if error == nil {
                if let array = object as? NSArray {
                    for element in array {
                        if let serverDictionary = element as? NSDictionary {
                            servers.append(Server(fromDictionary: serverDictionary))
                        }
                    }
                }
            } else {
                
            }
            completion(servers, error)
        }
    }
}
