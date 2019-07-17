//
//  ReplaceRootSegue.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

/// Replaces a root view controller of the root app view controller.
class ReplaceRootSegue: UIStoryboardSegue {
    
    override func perform() {
        if let rootAppViewController = source.rootAppViewController() {
            rootAppViewController.display(destination)
        }
    }
    
}
