import UIKit

protocol ServersViewDelegate: class {
    
    func logoutTapped(in viewController: ServersView)
}

final class ServersView: UIView {
    
    private var headerView: ServersTableHeaderView = {
        let view = ServersTableHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var logoImage: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let image = UIImage(named: "logout")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ServerTableViewCell.self, forCellReuseIdentifier: ServerTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        return tableView
    }()
    
    weak var delegate: ServersViewDelegate?
    
    private let viewModel: ServersViewModel
    
    init(viewModel: ServersViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupLogoImage()
        setupLogoutButton()
        setupHeaderView()
        setupTableView()
    }
    
    private func setupLogoImage() {
        addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func setupLogoutButton() {
        addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupHeaderView() {
        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableView() {
        addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            listTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        delegate?.logoutTapped(in: self)
    }
}

extension ServersView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ServersView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.reuseIdentifier, for: indexPath) as! ServerTableViewCell
        cell.server = viewModel.servers[indexPath.item]
        return cell
    }
}
