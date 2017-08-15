//
//  Auth.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Unbox

struct Auth: Unboxable {
    let token: String
    
    init(unboxer: Unboxer) throws {
        self.token =  try unboxer.unbox(key: "token")
    }
}
