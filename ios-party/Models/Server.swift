//
//  Server.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Server : Object, Mappable {
    @objc dynamic var name = ""
    @objc dynamic var distance : Int = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        distance <- map["distance"]
    }
}

