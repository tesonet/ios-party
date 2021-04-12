//
//  LoginView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI

struct LoginState {
    let username: String
    let password: String
}

enum LoginInput {
    case login
    
    case updateLogin(String)
    case updatePassword(String)
}


struct LoginView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
