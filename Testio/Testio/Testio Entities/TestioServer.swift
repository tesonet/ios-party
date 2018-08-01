//
//  TestioServer.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class TestioServer: Object, Codable {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
    
    dynamic var uuid = NSUUID().uuidString
    dynamic var name = ""
    dynamic var distance = 0.0
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
}
