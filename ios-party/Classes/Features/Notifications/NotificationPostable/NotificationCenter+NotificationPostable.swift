//
//  NotificationCenter+NotificationPostable.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

import Foundation

extension NotificationCenter {
    func post(_ postable: NotificationPostable, sender: Any? = nil) {
        dispatch_main_sync_safe {
            self.post(postable.notification(sender: sender))
        }
    }
}

extension NotificationPostable {
    fileprivate func notification(sender: Any?) -> Notification {
        return Notification(name: Self.name, object: sender, userInfo: [Self.name: self])
    }
}
