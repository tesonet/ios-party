//
//  ServersRequest.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class ServersRequest: AuthorizedRequest {
    override func endPoint() -> String {
        return "servers"
    }
    
    override func method() -> String {
        return "GET"
    }
}
