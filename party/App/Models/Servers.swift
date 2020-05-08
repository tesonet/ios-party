//
//  Servers.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation
import RealmSwift

final class Server: Object, Decodable {
    @objc dynamic var name: String
    @objc dynamic var distance: Int
    
    enum SortType: String {
        case distance = "By Distance"
        case alphanumerical = "Alphanumerical"
    }
}
