//
//  ServerData.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Unbox

struct ServerData: Unboxable {
    let something: String
    
    init(unboxer: Unboxer) throws {
        self.something =  try unboxer.unbox(key: "something")
    }
}
