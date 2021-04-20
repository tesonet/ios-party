//
//  ServerModel.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

struct ServerModel: Decodable {
    let name: String
    let distance: Int
}

extension ServerModel {
    func props() -> [String: Any] {
        return ["name" : name, "distance" : Int16(distance)]
    }
}
