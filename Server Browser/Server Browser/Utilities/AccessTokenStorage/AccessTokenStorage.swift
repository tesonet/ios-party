//
//  AccessTokenStorage.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

protocol AccessTokenStorage: class {
    var storedToken: String? { get set }
}
