//
//  Server.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import RealmSwift

class Server : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var distance : Int = 0
}
