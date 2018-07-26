//
//  String+Extensions.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation

extension String {
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
