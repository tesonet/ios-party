//
//  Server.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/26/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Server: Object, Codable {

    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0
    
    @objc dynamic var serverID = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "serverID"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
    
    convenience init(name: String, distance: Int) {
        self.init()
        self.name = name
        self.distance = distance
    }
}



