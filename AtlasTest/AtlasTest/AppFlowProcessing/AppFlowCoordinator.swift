//
//  AppFlowCoordinator.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

protocol Coordinator {
    func startProcessing(appFlowState: AppFlowState, dependencyContainer: DependencyContainer, resultHandler: ((AnyObject) -> Void)?)
    func onCompletion()
}

protocol FlowStateProcessor {
    var appFlowState: AppFlowState { get set }
    func initAppFlow()
    func defineAuthorizationState()
    func login()
    func displayContent()
    func onFatalError()
}

final class AppFlowStateProcessor: FlowStateProcessor {
    private unowned var dependency: DependencyContainer
    private var oldState: AppFlowState = .none
    var appFlowState: AppFlowState = .none {
        willSet(newValue) {
            oldState = appFlowState
        }
        didSet {
            guard oldState != .onFatalError else {
                appFlowState = .onFatalError
                return
            }
            appFlowState.processing(stateProcessor: self).process()
        }
    }
    init(dependency: DependencyContainer) {
        self.dependency = dependency
        self.dependency.flowStateProcessor = self
    }
   
    // MARK: - flow state actions
    func initAppFlow() {
        #if DEBUG
        print("AppFlowStateProcessor: initAppFlow")
        #endif
        dependency.errorHandler = ErrorHandler(dependency: dependency)
        dependency.apiWorker = ApiNetWorker(dependency: dependency)
        dependency.dataManager = DataStorageManager()
        dependency.dataManager?.initStorage()
        appFlowState = .undefined
    }
    
    func defineAuthorizationState() {
        #if DEBUG
        print("AppFlowStateProcessor: defineAuthorizationState")
        #endif
        //login(username: "tesonet", password: "partyanimal")
        guard LocalStorage.getToken() != nil && LocalStorage.getUserCredentials() != nil else {
            appFlowState = .notAuthorized
            return
        }
        appFlowState = .authorized
    }
    
    func login(username: String, password: String) {
        dependency.apiWorker?.login(username: "tesonet", password: "partyanimal") { [weak self] result in
            switch result {
            case .error(let error): print(error)
            case .response(let result):
                guard let token = result as? String else { return }
                LocalStorage.saveToken(token)
                self?.getServers()
            }
            
        }
    }
    
    func getServers() {
        dependency.apiWorker?.getServers() { result in
            switch result {
            case .error(let error): print(error)
            case .response(let result):
            print(result)
            }
        }
    }
    
    func login() {
        #if DEBUG
        print("AppFlowStateProcessor: login")
        #endif
        let loginCoordinator = LoginCoordinator(dependency: dependency)
        loginCoordinator.start()
    }
    
    func displayContent() {
        #if DEBUG
        print("AppFlowStateProcessor: displayContent")
        #endif
        let listCoordinator = ListCoordinator(dependency: dependency)
        listCoordinator.start()
    }
    
    func onFatalError() {
        #if DEBUG
        print("AppFlowStateProcessor: displayFatalError... do something?")
        #endif
    }
}




