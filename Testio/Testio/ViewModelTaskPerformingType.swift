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

enum TaskType {
    case authentication
    case serverRetrieval
}

extension TaskType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .authentication:
            return NSLocalizedString("TASK_AUTHENTICATION", comment: "")
        case .serverRetrieval:
            return NSLocalizedString("TASK_RETRIEVING_SERVERS", comment: "")
        }
    }
    
}

protocol ViewModelTaskPerformingType {
    
    var errors: Observable<ActionError> { get }
    var executing: Observable<Bool> { get }
    var taskType: TaskType { get }
    
}
