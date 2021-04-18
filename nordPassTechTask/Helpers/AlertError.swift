//
//  AlertError.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 17/04/2021.
//

import Foundation

struct AlertError: Identifiable {
    let id = UUID().uuidString
    let reason: String
}

extension NetworkError {
    var alertError: AlertError {
        AlertError(reason: self.errorDescription ?? "Something wrong happend")
    }
}

extension ServersJsonStoreError {
    var alertError: AlertError {
        AlertError(reason: self.errorDescription ?? "Something wrong happend")
    }
}
