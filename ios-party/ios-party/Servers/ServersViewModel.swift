struct ServersViewModel {
    
    struct Server {
        
        let name, distance: String
    }
    
    let servers: [Server]
    
    init(response: ServersResponse) {
        servers = response.servers.compactMap {
            Server(name: $0.name, distance: $0.distance.description)
        }
    }
}
