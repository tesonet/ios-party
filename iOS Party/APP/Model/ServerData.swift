//
//  ServerData.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Unbox

struct ServerData: Unboxable {
    let name:     String
    let distance: Int
    
    init(unboxer: Unboxer) throws {
        self.name =     try unboxer.unbox(key: "name")
        self.distance = try unboxer.unbox(key: "distance")
    }
}
