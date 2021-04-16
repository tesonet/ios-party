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
    var servers: [ServerDTO] = []
    var sortingOrder: SortingOrder = .descending
    var sortingBy: ServerSortedBy = .none
    var isOrderSheetPresented: Bool = false
    var error: AlertError? = nil
}

enum ServerInput {
    case initialFetch
    case updateIsOrderSheetPresented(Bool)
    case updateError(AlertError?)
}

struct ServersView: View {
    @ObservedObject var viewModel: AnyViewModel<ServersState, ServerInput>
    @EnvironmentObject var environment: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.servers.isEmpty {
                ProgressView(value: 0).progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.green)
                    .onAppear {
                        viewModel.trigger(.initialFetch)
                    }
            } else {
                HStack {
                    Text("SERVER")
                    Spacer()
                    Text("DISTANCE")
                }
                .padding(.horizontal)
                List(viewModel.servers, id: \.self) { server in
                    HStack {
                        Text(server.name)
                        Spacer()
                        Text("\(server.distance) km")
                    }
                }
                Button {
                    viewModel.trigger(.updateIsOrderSheetPresented(true))
                } label: {
                    Spacer()
                    HStack {
                        Image("sort")
                        Text("Sort")
                    }
                    .padding(.vertical, 16)
                    Spacer()
                }
                .foregroundColor(Color.white)
                .background(Color(red: 0.26, green: 0.27, blue: 0.39))
                
            }
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
    static let servers: [ServerDTO] = [ServerDTO(name: "Poland", distance: 1234) ]
    
    static var previews: some View {
        ServersView(viewModel: ServersViewModel<ImmediateScheduler>.mock(state: .mock(servers: servers)).eraseToAnyViewModel())
            .environmentObject(AppState.mock())
    }
}
#endif
