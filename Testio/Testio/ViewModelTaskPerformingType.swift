//
//  ViewModelTaskPerformingType.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol ViewModelTaskPerformingType {
    
    var errors: Observable<ActionError> { get }
    var executing: Observable<Bool> { get }
    
}
