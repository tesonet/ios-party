//
//  Navigator.swift
//  testio
//
//  Created by Justinas Baronas on 16/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit


/// Add this to confort to Navigator protocol for navigation
protocol Navigator {
    associatedtype Destination
    
    func navigate(from fromDestination: UIViewController, to destination: Destination)
    func navigate(to destination: Destination)
}
