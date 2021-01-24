//
//  Notification+NotificationPostable.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

extension Notification {
    func data<T: NotificationPostable>() -> T? {
        return userInfo?[T.name] as? T
    }
}
