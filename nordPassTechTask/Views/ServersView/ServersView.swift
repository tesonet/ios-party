//
//  ServersView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import SwiftUI
import Combine

enum SortingOrder {
    case descending
    case ascending
}

enum ServerSortedBy {
    case none
    case name
    case distance
}

struct ServersState {
    var servers: [Server] = []
    var sortingOrder: SortingOrder = .descending
    var sortedBy: ServerSortedBy = .none
    var isOrderSheetPresented: Bool = false
    var error: AlertError? = nil
}

enum ServerInput {
    case initialFetch
    case updateIsOrderSheetPresented(Bool)
    case updateError(AlertError?)
    case updateSortedBy(ServerSortedBy)
}

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
    @Binding var server: Server
    
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text(server.distanceFormatted)
        }
        .font(Font.body.weight(.light))
        .foregroundColor(Color("primaryText"))
    }
}

struct ServersView: View {
    @ObservedObject var viewModel: AnyViewModel<ServersState, ServerInput>
    @EnvironmentObject var environment: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.servers.isEmpty {
                ZStack {
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea(.container)
                    ServersProgressView()
                        .onAppear {
                            withAnimation {
                                viewModel.trigger(.initialFetch)
                            }
                        }
                }
            } else {
                ServersHeaderView()
                List(viewModel.servers, id: \.self) { server in
                    if viewModel.servers.first == server  {
                        ServersRowView(server: .constant(server))
                            .padding(.bottom, UIConstraints.Layout.innerSpacing)
                            .padding(.top, UIConstraints.Layout.innerSpacing + 12)
                    } else {
                        ServersRowView(server: .constant(server))
                            .padding(.vertical, UIConstraints.Layout.innerSpacing)
                    }
                }
                .zIndex(-1)
                .layoutPriority(1)
                Button {
                    viewModel.trigger(.updateIsOrderSheetPresented(true))
                } label: {
                    Spacer()
                    HStack {
                        Image("sort")
                        Text("Sort")
                    }
                    .padding(.vertical, UIConstraints.Layout.margin)
                    Spacer()
                }
                .foregroundColor(Color.white)
                .background(Color("buttonBackground"))
                
            }
        }
        .actionSheet(isPresented: viewModel.binding(\.isOrderSheetPresented, with: ServerInput.updateIsOrderSheetPresented)) {
            ActionSheet(title: Text("Sort by"), message: nil, buttons: [
                .default(Text("Distance"), action: {
                    withAnimation {
                        viewModel.trigger(.updateSortedBy(.distance))
                    }
                }),
                .default(Text("Alphanumerical"), action: {
                    withAnimation {
                        viewModel.trigger(.updateSortedBy(.name))
                    }
                }),
                .cancel()
            ])
        }
        .alert(item: viewModel.binding(\.error, with: ServerInput.updateError)) { error -> Alert in
            Alert(title: Text(error.reason), dismissButton: .default(Text("Retry"), action: {
                viewModel.trigger(.initialFetch)
            }))
        }
        .navigationBarItems(
            leading: Image("logo"),
            trailing:
                Button {
                    environment.token = nil
                    
                } label: {
                    Image("logout")
                }
        )
        .navigationBarHidden(false)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct ServersView_Previews: PreviewProvider {
    static let servers: [Server] = [Server(name: "Poland", distance: 1234)]
    
    static var previews: some View {
        ServersView(viewModel: ServersViewModel<ImmediateScheduler>.mock(state: .mock(servers: servers)).eraseToAnyViewModel())
            .environmentObject(AppState.mock())
    }
}
#endif
