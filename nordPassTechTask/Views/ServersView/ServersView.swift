//
//  ServersView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI
import ComposableArchitecture

private struct ServersHeaderView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.primary)
                .colorInvert()
                .shadow(color: Color("shadow"), radius: 30, x: 0.0, y: 0.0)
            HStack {
                Text("SERVER")
                Spacer()
                Text("DISTANCE")
            }
            .font(.subheadline)
            .foregroundColor(Color("gray"))
            .padding(UIConstraints.Layout.margin)
        }
    }
}

private struct ServersRowView: View {
    let server: Server
    
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text("\(server.distance.distance()) km")
        }
        .font(Font.body.weight(.light))
        .foregroundColor(Color("primaryText"))
    }
}

struct ServersView: View {
    let store: Store<ServersState, LifecycleAction<ServersAction>>
    
    var body: some View {
        WithViewStore(store) { (viewStore: ViewStore<ServersState, ServersAction>) in
            let servers = viewStore.sortedServers
            VStack(spacing: 0) {
                if servers.isEmpty {
                    ZStack {
                        Image("background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea(.container)
                        ServersProgressView()
                    }
                } else {
                    ServersHeaderView()

                    List(servers, id: \.self) { server in
                        if servers.first == server  {
                            ServersRowView(server: server)
                                .padding(.bottom, UIConstraints.Layout.innerSpacing)
                                .padding(.top, UIConstraints.Layout.innerSpacing + 12)
                        } else {
                            ServersRowView(server: server)
                                .padding(.vertical, UIConstraints.Layout.innerSpacing)
                        }
                    }
                    .zIndex(-1)
                    .layoutPriority(1)

                    Button(
                        action: {
                            viewStore.send(.orderSheetButtonTapped)

                        },
                        label: {
                            Spacer()
                            HStack {
                                Image("sort")
                                Text("Sort")
                            }
                            .padding(.vertical, UIConstraints.Layout.margin)
                            Spacer()
                        }
                    )
                    .foregroundColor(Color.white)
                    .background(Color("buttonBackground"))
                    .zIndex(1)
                    .actionSheet(store.scope(state: \.orderSheet), dismiss: .orderSheetDismissed)
                }
            }
            .alert(store.scope(state: \.errorAlert), dismiss: ServersAction.errorAlertDismissed)
            .navigationBarHidden(false)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                leading: Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20),
                trailing: Button(
                    action: { viewStore.send(.logout) },
                    label: {
                        Image("logout")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16, alignment: .bottom)
                    }
                )
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#if DEBUG
struct ServersView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencies = GlobalDependencies.mock
        ServersView(
            store: Store(
                initialState: ServersState(),
                reducer: ServersReducer.reducer,
                environment: GlobalEnvironment.mock(
                    mainQueue: { .main },
                    environment: ServersEnvironment(dependencies),
                    dependencies: dependencies
                )
            )
            .scope(state: { $0! })
        )
    }
}
#endif

private extension Int {
    static let numberFormatter = NumberFormatter()
    
    func distance() -> String {
        Self.numberFormatter.numberStyle = .none
        return Self.numberFormatter.string(from: NSNumber(integerLiteral: self)) ?? ""
    }
}
