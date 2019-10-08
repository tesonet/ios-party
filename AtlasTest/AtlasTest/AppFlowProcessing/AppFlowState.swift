//
//  AppFlowState.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

enum AppFlowState: String {
    case none
    case undefined
    case notAuthorized
    case authorized
    case onFatalError
    
    static var stateProcessor: DependencyContainer?
    
    private func name() -> String {
        switch self {
        case .none: return("appFlowStateNone")
        case .undefined: return("authorizationStateUndefined")
        case .notAuthorized: return("notAuthorized")
        case .authorized: return("isAuthorized")
        case .onFatalError: return("appOnFatalError")
        }
    }
    
    func processing(stateProcessor: FlowStateProcessor) -> AppStateProcessing {
        switch self {
        case .none: return process(with: stateProcessor, action: { stateProcessor.initAppFlow() })
        case .undefined: return process(with: stateProcessor, action: { stateProcessor.defineAuthorizationState() })
        case .notAuthorized: return process(with: stateProcessor, action: { stateProcessor.login() })
        case .authorized: return process(with: stateProcessor, action: { stateProcessor.displayContent() })
        case .onFatalError: return process(with: stateProcessor, action: { stateProcessor.onFatalError() })
        }
    }
    
    // MARK: - App flow states processing setup
    private func process(with processor: FlowStateProcessor, action: @escaping () -> Void) -> AppStateProcessing {
        let stateProcessor = AppStateProcessor(action: action)
        return AppStateProcessing(id: self, processor: stateProcessor)
    }
}
