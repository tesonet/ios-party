//
//  Server.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 29.05.2021.
//

import Foundation

struct Server: Hashable {
    let name: String
    let distance: Int
    
    init(name: String, distance: Int) {
        self.name = name
        self.distance = distance
    }
}

extension Server: Codable {}

#if DEBUG
extension Server {
    static let mockList: [Server] = [
        Server(name: "Sweden", distance: 1234),
        Server(name: "Poland", distance: 10),
        Server(name: "Montenegro", distance: 4000),
    ]
}
#endif
