//
//  ResponseParser.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResponseParser{
    
    static func parseToken(json : JSON) -> String{
        return json["token"].stringValue
    }
}
