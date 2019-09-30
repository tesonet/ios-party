//
//  AppStateProcessing.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

protocol StateProcessor {
    var isCompleted: Bool { get set }
    var action: () -> Void { get set }//Completable { get set }
}

protocol Command {
    func process()
}

// MARK: - state Processor with completion handler
struct AppStateProcessor: StateProcessor {
    private var privateIsCompleted: Bool = false
    private var lock = ReadWriteLock()
    var action:  () -> Void //Completable
    var isCompleted: Bool {
        get {
            lock.readLock()
            let value = privateIsCompleted
            lock.unlock()
            return value
        }
        set {
            lock.writeLock()
            privateIsCompleted = newValue
            lock.unlock()
        }
    }
    
    init(action: @escaping  () -> Void) { //Completable) {
        self.action = action
    }
}

// MARK: - App state processing data structure: contains state id, processor method
struct AppStateProcessing: Command {
    var id: AppFlowState
    var processor: StateProcessor
    
    init(id: AppFlowState, processor: StateProcessor) {
        self.id = id
        self.processor = processor
    }
    
    func process () {
        processor.action()
    }
}
