//
//  ThreadSafetyTools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

// MARK: - Main Thread
func dispatch_main_sync_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread {
        callback()
    } else {
        DispatchQueue.main.sync {
            callback()
        }
    }
}

func dispatch_main_async_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread {
        callback()
    } else {
        DispatchQueue.main.async {
            callback()
        }
    }
}

// MARK: - Background Thread
func dispatch_background_sync_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread == false {
        callback()
    } else {
        DispatchQueue.global().sync {
            callback()
        }
    }
}

func dispatch_background_async_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread == false {
        callback()
    } else {
        DispatchQueue.global().async {
            callback()
        }
    }
}
