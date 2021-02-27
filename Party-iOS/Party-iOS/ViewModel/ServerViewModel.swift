//
//  ServerViewModel.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

struct ServerViewModel {
    
    private let server: Server
    
    init(server: Server) {
        self.server = server
    }
    
    var name: String {
        server.name ?? ""
    }
    
    var distance: String {
        guard let distance = server.distance else { return "" }
        return "\(distance) km"
    }
}
