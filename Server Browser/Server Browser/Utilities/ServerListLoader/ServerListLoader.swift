//
//  ServerListLoader.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

protocol ServerListLoader {
    func requestAccessToken(forUser: String,
                            password: String,
                            completionHandler: @escaping (String?, Error?) -> Void)

    func fetchServerList(withAccessToken: String,
                         completionHandler: @escaping ([Server]?, Error?) -> Void)
}
