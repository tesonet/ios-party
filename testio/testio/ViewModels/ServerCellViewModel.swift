import Foundation

struct ServerCellViewModel {
    private let server: Server
    
    var serverName: String { return server.name }
    var distance: String { return "\(server.distance) km" }
    
    init(server: Server) {
        self.server = server
    }
}
