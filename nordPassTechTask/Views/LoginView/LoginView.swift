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
    var isFormValid: Bool
    var isBusy: Bool = false
    
    init(username: String = "", password: String = "", error: String? = nil, isBusy: Bool = false) {
        self.username = username
        self.password = password
        self.error = error
        self.isFormValid = !username.isEmpty && !password.isEmpty
        self.isBusy = isBusy
    }
}

enum LoginInput {
    case login
    
    case updateUsername(String)
    case updatePassword(String)
}

struct LoginView: View {
    @ObservedObject var viewModel: AnyViewModel<LoginState, LoginInput>
    @EnvironmentObject var env: AppState
    
    var body: some View {
        VStack(spacing: UIConstraints.Layout.innerSpacing) {
            Spacer()
            Image("logo-white")
            Spacer()
            HStack(spacing: UIConstraints.Layout.innerSpacing) {

                Image(systemName: "person.fill")
                TextField("Username", text: viewModel.binding(\.username, with: LoginInput.updateUsername))
                    .textContentType(.username)
            }
            .padding(.all, UIConstraints.Layout.margin)
            .background(Color.white)
            .cornerRadius(UIConstraints.Layout.cornerRadius)
            
            HStack {
                Image(systemName: "lock.fill")
                SecureField("Password", text: viewModel.binding(\.password, with: LoginInput.updatePassword))
                    .textContentType(.password)
            }
            .padding(.all, UIConstraints.Layout.margin)
            .background(Color.white)
            .cornerRadius(UIConstraints.Layout.cornerRadius)
            
            NavigationLink(
                destination: ServersView(
                    viewModel: ServersViewModel<DispatchQueue>(
                        state: ServersState(),
                        with: ServersRepository(appState: env),
                        store: ServersJsonStore(jsonName: "servers.json"),
                        on: DispatchQueue.main).eraseToAnyViewModel()),
                isActive: .constant(env.token != nil),
                label: {
                    LoginButton {
                        viewModel.trigger(.login)
                    }
                }
            )
            .disabled(!viewModel.isFormValid)
            .busy(viewModel.isBusy)
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption2)
            }
            Spacer()
        }
        .accentColor(Color("gray"))
        .foregroundColor(Color("gray"))
        .textFieldStyle(PlainTextFieldStyle())
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationBarHidden(true)
        .padding(.horizontal , UIConstraints.Layout.margin)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel<ImmediateScheduler>.mock(state: .mock()).eraseToAnyViewModel())
            .environmentObject(AppState.mock())
    }
}
