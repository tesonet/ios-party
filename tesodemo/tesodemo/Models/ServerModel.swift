//
//  ServerModel.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit

class ServerModel: NSObject {
    var name: String = ""
    var distance: Int = 0

    init(json: [String: Any]) {
        name = (json["name"] as? String) ?? ""
        distance = (json["distance"] as? Int) ?? 0
    }
    
}
