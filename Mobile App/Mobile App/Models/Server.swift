//
//  Server.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import RealmSwift

final class Server: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0
    
    override static func primaryKey() -> String {
        return "name"
    }
}
