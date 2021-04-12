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
    var servers: [ServerDTO]
    var sortingOrder: SortingOrder
    var sortingBy: ServerSortedBy
    var isOrderSheetPresented: Bool
}

enum ServerInput {
    case updateIsOrderSheetPresented(Bool)
}

struct ServersView: View {
    @ObservedObject var viewModel: AnyViewModel<ServersState, ServerInput>
    @EnvironmentObject var environment: AppState
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct ServersView_Previews: PreviewProvider {
    static var previews: some View {
        ServersView(viewModel: ServerViewModel<ImmediateScheduler>.mock(state: .mock()).eraseToAnyViewModel())
            .environmentObject(AppState.mock())
    }
}
#endif
