//
//  DataItem.swift
//  GreatiOSApp
//
//  Created by Domas on 4/6/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit

class DataItem: NSObject {
    
    var distance: Int = 0
    var name: String = ""
    
    init(dataWithDictionary dic: Dictionary<String, Any>) {
        super.init()
        distance = dic["distance"] as! Int
        name = dic["name"] as! String
    }

}
