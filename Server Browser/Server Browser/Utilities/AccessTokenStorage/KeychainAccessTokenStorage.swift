//
//  KeychainAccessTokenStorage.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Foundation

class KeychainAccessTokenStorage: AccessTokenStorage {
    let serverURL: URL
    
    private lazy var protectionSpace: URLProtectionSpace = {
        [unowned self] in
        let url = self.serverURL
        return URLProtectionSpace(host: url.host ?? "unknown host",
                                  port: url.port ?? 0,
                                  protocol: url.scheme,
                                  realm: nil,
                                  authenticationMethod: nil)
    }()
    
    init(serverURL: URL) {
        self.serverURL = serverURL
    }
    
    // MARK: - AccessTokenStorage
    
    var storedToken: String? {
        get {
            let storedCredentials = URLCredentialStorage.shared.credentials(for: protectionSpace)
            if let (_, credential) = storedCredentials?.first {
                if let token = credential.password {
                    return token
                }
                else {
                    URLCredentialStorage.shared.remove(credential, for: protectionSpace)
                }
            }
            return nil
        }
        
        set {
            let credentialStorage = URLCredentialStorage.shared
            if let storedCredentials = credentialStorage.credentials(for: protectionSpace) {
                for (_, credential) in storedCredentials {
                    credentialStorage.remove(credential, for: protectionSpace)
                }
            }
            
            guard let newToken = newValue else {
                return
            }
            
            let urlCredential = URLCredential(user: "token",
                                              password: newToken,
                                              persistence: URLCredential.Persistence.permanent)
            credentialStorage.set(urlCredential, for: protectionSpace)
        }
    }
}
