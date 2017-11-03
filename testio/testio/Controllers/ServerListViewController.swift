import UIKit

private let estimatedRowHeight = CGFloat(44)
private let estimatedHeaderHeight = CGFloat(44)

class ServerListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let sectionHeaderView = ServerListHeaderView.loadFromNib()
    
    var onLogOut: (() -> Void)?
    var servers: Servers? {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Actions
    
    @IBAction func logoutAction(_ sender: Any) {
        Authentication.destroy()
        onLogOut?()
    }
    
    // MARK: Setup
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = estimatedHeaderHeight
        
        tableView.register(
            ServerTableViewCell.nib(),
            forCellReuseIdentifier: ServerTableViewCell.reuseIdentifier()
        )
    }
}

extension ServerListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let servers = servers {
            return servers.all.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerTableViewCell.reuseIdentifier(),
            for: indexPath
        ) as! ServerTableViewCell
        
        if let servers = servers {
            cell.configure(with: ServerCellViewModel(server: servers.all[indexPath.row]))
        }
        
        return cell
    }
}
