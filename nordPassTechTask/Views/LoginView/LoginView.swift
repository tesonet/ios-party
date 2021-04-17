//
//  LoginView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI
import Combine

struct LoginState {
    var username: String = ""
    var password: String = ""
    var error: String? = nil
}

enum LoginInput {
    case login
    
    case updateLogin(String)
    case updatePassword(String)
}


struct LoginView: View {
    @ObservedObject var viewModel: AnyViewModel<LoginState, LoginInput>
    @EnvironmentObject var env: AppState
    
    var body: some View {
        return VStack {
            Spacer()
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption2)
            }
            TextField("Username", text: viewModel.binding(\.username, with: LoginInput.updateLogin))
                .textContentType(.username)
            SecureField("Password", text: viewModel.binding(\.password, with: LoginInput.updatePassword))
                .textContentType(.password)
            NavigationLink(
                destination: ServersView(
                    viewModel: ServersViewModel<DispatchQueue>(
                        state: ServersState(),
                        with: ServersRepository(appState: env),
                        store: ServersJsonStore(jsonName: "servers.json"),
                        on: DispatchQueue.main).eraseToAnyViewModel()),
                isActive: .constant(env.token != nil),
                label: {
                    Button("Login") {
                        viewModel.trigger(.login)
                    }
                }
            )
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationBarHidden(true)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel<ImmediateScheduler>.mock(state: .mock()).eraseToAnyViewModel())
            .environmentObject(AppState.mock())
    }
}
