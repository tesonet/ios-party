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
    var oldState: AppFlowState { get }
    func initAppFlow()
    func defineAuthorizationState()
    func login()
    func displayContent()
    func onFatalError()
}

final class AppFlowStateProcessor: FlowStateProcessor {
    private var dependency: DependencyContainer
    private var loginCoordinator: LoginCoordinator?
    private var listCoordinator: ListCoordinator?
    
    var oldState: AppFlowState = .none
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
        guard let loadingViewController = LoadingViewController.makeLoadingViewController() else {  return }
        guard let window = dependency.window else { return }
        
        window.rootViewController = loadingViewController
        window.makeKeyAndVisible()
        
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
    
    func login() {
        #if DEBUG
        print("AppFlowStateProcessor: login")
        #endif
        loginCoordinator = AppLoginCoordinator(dependency: dependency) { [weak self] isLogged in
            guard isLogged else { return }
            self?.appFlowState = .authorized
        }
        loginCoordinator?.start()
    }
    
    func displayContent() {
        #if DEBUG
        print("AppFlowStateProcessor: displayContent")
        #endif
        listCoordinator = AppListCoordinator(dependency: dependency)
        listCoordinator?.start()
    }
    
    func onFatalError() {
        #if DEBUG
        print("AppFlowStateProcessor: displayFatalError... do something?")
        #endif
    }
}




