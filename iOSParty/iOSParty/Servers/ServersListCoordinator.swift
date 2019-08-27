import UIKit
import UserInterface
import Servers
import User

final class ServersListCoordinator: NSObject {
    
    override init() {
        super.init()
    }
    
    private var servers: [ServerModel]? {
        if let currentRefine = currentRefineAction {
            return Servers.shared.servers?.sorted(by: { (lhs, rhs) -> Bool in
                switch currentRefine {
                case 0: return lhs.distance < rhs.distance
                case 1: return lhs.name! < rhs.name!
                default: return false
                }
            })
        }
        return Servers.shared.servers
    }
    
    private var refineActions = ["By Distance", "Alphanumerically"]
    private var currentRefineAction: Int?
    private lazy var sortVC: RefineVC = {
        let vc = RefineVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.delegate = self
        vc.setRefineActions(refineActions)
        return vc
    }()
    
    private lazy var contentVC: UIViewController = {
        let vc = UIViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        let keyBar = KeyBar()
        keyBar.translatesAutoresizingMaskIntoConstraints = false
        keyBar.set(leftKey: "SERVER", rightKey: "DISTANCE")
        keyBar.backgroundColor = .white
        vc.view.addSubview(keyBar)
        NSLayoutConstraint.activate([
            keyBar.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            keyBar.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            keyBar.topAnchor.constraint(equalTo: vc.view.topAnchor),
            keyBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        vc.addChild(listVC)
        vc.view.insertSubview(listVC.view, belowSubview: keyBar)
        
        vc.addChild(sortVC)
        vc.view.addSubview(sortVC.view)
        NSLayoutConstraint.activate([
            sortVC.view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            sortVC.view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            sortVC.view.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
            sortVC.view.heightAnchor.constraint(equalToConstant: 55),
            
            listVC.view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            listVC.view.topAnchor.constraint(equalTo: keyBar.bottomAnchor),
            listVC.view.bottomAnchor.constraint(equalTo: sortVC.view.topAnchor)
            ])
        return vc
    }()
    
    private lazy var listVC: UITableViewController = {
        let vc = UITableViewController()
        vc.tableView.register(ServerListCell.self, forCellReuseIdentifier: "cell")
        vc.tableView.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
}

extension ServersListCoordinator {
    
    var viewController: UIViewController { return contentVC }
    
    func start() {
        if let token = User().info?.token {
            Servers.shared.changeHandler = self
            Servers.shared.fetch(with: token)
        }
    }
}

//MARK: - SERVERS
extension ServersListCoordinator: ServersChangeHandler {
    
    func serversFetchCompleted() {
        DispatchQueue.main.async { [weak self] in
            self?.listVC.tableView.reloadData()
        }
    }
}

extension ServersListCoordinator: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ServerListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServerListCell
        if let server = servers?[indexPath.row] {
            cell.set(server: "\(server.name!)", distance: "\(server.distance) km")
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension ServersListCoordinator: RefineVCDelegate {
    
    func refineVCDidSelect(itemAtIndex index: Int) {
        guard refineActions.indices.contains(index) else { return }
        currentRefineAction = index
        listVC.tableView.reloadData()
    }
}
