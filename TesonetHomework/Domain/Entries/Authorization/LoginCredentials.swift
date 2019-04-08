// Created by Paulius Cesekas on 02/04/2019.

import Foundation

public struct LoginCredentials {
    public var username: String
    public var password: String

    public init(username: String,
                password: String) {
        self.username = username
        self.password = password
    }
}
