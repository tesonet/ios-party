import RxSwift

protocol ServersListViewControllerDelegate: class {
    func serversListDidChanged()
}

protocol ServersViewModelType {
    var delegate: ServersListViewControllerDelegate? { get set }
    var serversList: [Server] { get set }
    func retrieveAllServers()
}

class ServersViewModel: ServersViewModelType {
    weak var delegate: ServersListViewControllerDelegate?
    var serversList: [Server] = [] {
        didSet {
            delegate?.serversListDidChanged()
        }
    }
    private let serversListInteractor: ServersListInteractor
    private let disposeBag = DisposeBag()
    
    init(serversListInteractor: ServersListInteractor) {
        self.serversListInteractor = serversListInteractor
    }
    
    func retrieveAllServers() {
        serversListInteractor
            .request()
            .subscribe(
                onSuccess: { [weak self] servers in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        ErrorMessageHud.showError(with: "")
                    }
                    self.serversList = servers
                    self.save(data: servers)
                },
                onError: { error in
                    DispatchQueue.main.async {
                        ErrorMessageHud.showError(with: error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
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
