//
//  LoginButton.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 18/04/2021.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        LoginButton(configuration: configuration)
    }
    
    struct LoginButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.callout)
                .foregroundColor(.white)
                .background(isEnabled ? Color("green") : Color("gray"))
        }
    }
}

struct LoginButton: View {
    var action: () -> Void
    @Environment(\.busy) private var busy: Bool
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: UIConstraints.Layout.margin * 3)
                    if busy {
                        ProgressView(value: 0)
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Log In")
                    }
                }
                Spacer()
            }
        })
        .buttonStyle(LoginButtonStyle())
        .cornerRadius(UIConstraints.Layout.cornerRadius)
    }
}
