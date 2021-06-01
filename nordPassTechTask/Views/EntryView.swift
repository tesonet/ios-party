//
//  EntryView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 13/04/2021.
//

import SwiftUI
import ComposableArchitecture

struct EntryView: View {
    private let _environment: GlobalEnvironment<LoginEnvironment> = {
        let dependencies = GlobalDependencies.live
        return GlobalEnvironment.live(environment: LoginEnvironment(dependencies), dependencies: dependencies)
    }()
    
    var body: some View {
        NavigationView {
            LoginView(
                store: Store(
                    initialState: LoginState(),
                    reducer: LoginReducer.reducer,
                    environment: _environment
                )
            )
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .ignoresSafeArea(.container, edges: .top)
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
