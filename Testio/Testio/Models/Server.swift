//
//  Server.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import RealmSwift

class Server: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0
    
    override static func primaryKey() -> String {
        return "name"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
}
