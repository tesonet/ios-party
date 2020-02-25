//
//  UserModel.swift
//  Tesonet
//

import SwiftyJSON

class Model {
}

class LoginModel: Model {

    let userName: String
    let password: String

    init?(userName: String?, password: String?) {
        guard let name = userName, name.count > 0, let password = password, password.count > 0 else {
            return nil
        }
        self.userName = name
        self.password = password
    }
}

class UserModel: Model {

    let token: String

    init?(with dict: [String: Any]?) {
        guard let token = dict?["token"] as? String else {
            return nil
        }
        self.token = token
    }
}
