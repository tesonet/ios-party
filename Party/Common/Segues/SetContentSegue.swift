//
//  SetContentSegue.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

// Sets destination controller as content controller.
class SetContentSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let rootViewController = source as? RootAppViewController else {
            return
        }
        rootViewController.display(destination)
    }
}
