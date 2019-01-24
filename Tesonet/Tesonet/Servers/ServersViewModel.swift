protocol ServersViewControllerDelegate: class {
    func serversListDidChanged()
}

protocol ServersViewModelType {
    var delegate: ServersViewControllerDelegate? { get set }
    var serversList: [Server] { get set }
    func fetchData()
}

class ServersViewModel: ServersViewModelType {
    weak var delegate: ServersViewControllerDelegate?
    var serversList: [Server] = [] {
        didSet {
            delegate?.serversListDidChanged()
        }
    }
    
    func fetchData() {
        guard let accessToken = UserSession.shared.token else {
            return
        }
        NetworkClient.shared.loadData(from: URLs.Tesonet.dataURL, with: accessToken) { [weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
                return
            }
            
            guard let result = result else {
                return
            }
            
            self.serversList = result
            
            self.save(data: result)
        }
    }
}

// MARK: - Privates

extension ServersViewModel {
    fileprivate func save(data: [Server]) {
        RealmStore.shared.add(items: data)
    #if DEBUG
        let servers = RealmStore.shared.retrieve()
        print("---> ", servers, " <---")
    #endif
    }
}
