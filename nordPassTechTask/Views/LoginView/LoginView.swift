//
//  LoginView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI
import ComposableArchitecture

struct LoginButton: View {
    let isEnabled: Bool
    let inProgress: Bool
    
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                if inProgress {
                    ProgressView(value: 0.0)
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Log In")
                        .font(.headline)
                }
            }
            Spacer()
        }
        .foregroundColor(.white)
        .background(isEnabled ? Color("green") : Color("gray"))
        .cornerRadius(UIConstraints.Layout.cornerRadius)
    }
}

//struct LoginButton_Preview: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LoginButton(isEnabled: true, inProgress: true)
//        }
//    }
//}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: UIConstraints.Layout.innerSpacing) {
                Spacer()
                
                Image("logo-white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                
                Spacer()
                
                VStack(spacing: 8) {
                    HStack(spacing: UIConstraints.Layout.innerSpacing) {
                        Image(systemName: "person.fill")
                        TextField("Username", text: viewStore.binding(get: \.username, send: LoginAction.updateUsername))
                            .textContentType(.username)
                    }
                    .padding(.all, UIConstraints.Layout.margin)
                    .frame(height: UIConstraints.Layout.inputFieldHeight)
                    .background(Color.white)
                    .cornerRadius(UIConstraints.Layout.cornerRadius)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                        SecureField("Password", text: viewStore.binding(get: \.password, send: LoginAction.updatePassword))
                            .textContentType(.password)
                    }
                    .padding(.all, UIConstraints.Layout.margin)
                    .frame(height: UIConstraints.Layout.inputFieldHeight)
                    .background(Color.white)
                    .cornerRadius(UIConstraints.Layout.cornerRadius)
                    
                    NavigationLink(
                        destination:
                            IfLetStore(
                                self.store.scope(
                                    state: \.serverState,
                                    action: LoginAction.optionalServers
                                ),
                                then: ServersView.init(store:)
                            )
                        ,
                        isActive: viewStore.binding(
                            get: \.navigatedToServers,
                            send: LoginAction.navigateToServers(isActive:)
                        ),
                        label: {
                            LoginButton(isEnabled: viewStore.isFormValid, inProgress: viewStore.inProgress)
                        }
                    )
                    .frame(height: UIConstraints.Layout.inputFieldHeight)
                    .disabled(!viewStore.isFormValid || viewStore.inProgress)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                    
                Spacer()
            }
            .alert(store.scope(state: \.errorAlert), dismiss: .errorAlertDismissed)
            .accentColor(Color("gray"))
            .foregroundColor(Color("gray"))
            .textFieldStyle(PlainTextFieldStyle())
            .navigationBarHidden(true)
            .padding(.horizontal , UIConstraints.Layout.margin)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = GlobalDependencies.mock
        NavigationView {
            LoginView(
                store: Store(
                    initialState: LoginState(),
                    reducer: LoginReducer.reducer,
                    environment: GlobalEnvironment.mock(
                        mainQueue: { .main },
                        environment: LoginEnvironment(dependencies),
                        dependencies: dependencies
                    )
                )
            )
        }
    }
}
