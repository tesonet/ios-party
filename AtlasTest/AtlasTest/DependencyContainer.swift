//
//  DependencyContainer.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

protocol DependencyContainer: AnyObject {
    var window: UIWindow? { get set }
    var flowStateProcessor: FlowStateProcessor? { get set }
    var errorHandler: ErrorHandler? { get set }
    var apiWorker: ApiWorker? { get set }
    var dataManager: DataManager? { get set }
}

final class AppDependencyContainer: DependencyContainer {
    var window: UIWindow?
    var flowStateProcessor: FlowStateProcessor?
    var errorHandler: ErrorHandler?
    var apiWorker: ApiWorker?
    var dataManager: DataManager?
    
    init() {
        
    }
}
