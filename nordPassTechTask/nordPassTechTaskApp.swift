//
//  nordPassTechTaskApp.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI
import Combine

@main
struct nordPassTechTaskApp: App {
    
    @StateObject var appState = AppState(token: nil)
    
    var body: some Scene {
        WindowGroup {
            ServersView(viewModel: ServerViewModel<ImmediateScheduler>.mock(state: .mock()).eraseToAnyViewModel())
                .environmentObject(appState)
        }
    }
}
