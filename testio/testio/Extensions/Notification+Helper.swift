//
//  Notification+Helper.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

extension Notification {
    
    static var loggedIn: Name {
        return Name(#function)
    }
    static var logOut: Name {
        return Name(#function)
    }
}

extension Notification.Name {
    
    /// Convenience method for calling `NotificationCenter.default.post(name: self, object: nil)`
    func post() {
        NotificationCenter.default.post(name: self, object: nil)
    }
    
    /// Convenience method for calling `NotificationCenter.default.addObserver(observer, selector: selector, name: self, object: nil)`
    ///
    /// - Parameters:
    ///   - observer: Object registering as an observer.
    ///   - selector: Selector that specifies the message the receiver sends observer to notify it of the notification posting. The method specified by aSelector must have one and only one argument (an instance of NSNotification).
    func observe(with observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: self, object: nil)
    }
    
    /// Convenience method for calling `NotificationCenter.default.addObserver(forName: self, object: nil, queue: .main, using: block)`
    ///
    /// - Parameter block: The block to be executed when the notification is received.
    /// - Returns: An opaque object to act as the observer.
    func observe(using block: @escaping (Notification) -> ()) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: nil, queue: .main, using: block)
    }
}
