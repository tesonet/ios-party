//
//  Server.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

class Server {
    let name: String
    let distance: Int
    
    init?(jsonDictionary: [String: Any]) {
        guard let name = jsonDictionary["name"] as? String,
            let distance = jsonDictionary["distance"] as? Int else {
                return nil
        }
        
        self.name = name
        self.distance = distance
    }
}
