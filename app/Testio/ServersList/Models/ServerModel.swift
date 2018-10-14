//
//  ServerModel.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import Realm
import RealmSwift

class ServerModel: Object, Decodable {
    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0
}
