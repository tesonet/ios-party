//
//  EntryView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 13/04/2021.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var environment: AppState
    
    var body: some View {
        NavigationView {
            LoginView(
                viewModel: LoginViewModel<DispatchQueue>(
                    with: LoginRepository(),
                    appState: environment,
                    on: DispatchQueue.main
                ).eraseToAnyViewModel()
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
        EntryView().environmentObject(AppState.mock())
    }
}
