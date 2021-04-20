//
//  Server+Extension.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

extension Server {
    func toModel() -> ServerModel {
        return ServerModel(name: name ?? "", distance: Int(distance))
    }
}
