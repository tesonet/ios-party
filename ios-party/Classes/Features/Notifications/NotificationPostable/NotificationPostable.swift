//
//  NotificationPostable.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

protocol NotificationPostable {
    /// By default it be a class name which implements this protocol
    static var name: Notification.Name { get }
}

extension NotificationPostable {
    static var name: Notification.Name {
        return Notification.Name(String(describing: self))
    }
}
