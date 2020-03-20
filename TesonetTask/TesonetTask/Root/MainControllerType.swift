//
//  MainControllerType.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

enum MainControllerType {
    case auth
    case main
    
    var controller: UIViewController {
        switch self {
        case .auth:
            return AuthViewController()
        case .main:
            return MainViewController()
        }
    }
    
}
