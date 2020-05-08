//
//  Servers.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

struct Server: Decodable, Equatable {
    let name: String
    let distance: Int
}
