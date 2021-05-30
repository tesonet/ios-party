//
//  AppState.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var token: String?
    
    init(token: String?) {
        self.token = token
    }
}

#if DEBUG
extension AppState {
    static func mock(token: String? = nil) -> AppState {
        AppState(token: token)
    }
}
#endif
