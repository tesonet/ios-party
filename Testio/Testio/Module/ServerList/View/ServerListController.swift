//
//  ServerListController.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

final class ServerListController: UIViewController, ServerListView {
    
    enum Constants {
        static var sortButtonBgColor: UIColor {
            UIColor(named: "purpleLight")!
        }
        
        static var sortButtonTintColor: UIColor {
            UIColor(named: "purpleLight")!
        }
        
        static var sortButtonFont: UIFont {
            UIFont.systemFont(ofSize: 14)
        }
        
        static var logoutButtonColor: UIColor {
            UIColor(named: "purpleDark")!
        }
        
        static var sortButtonHeight: CGFloat {
            44
        }
        
        static var cellIdentifier: String {
            "cell"
        }
        
        static var tableViewContentInset: UIEdgeInsets {
            .init(top: 8, left: 0, bottom: 0, right: 0)
        }
        
        static var statusLabelColor: UIColor {
            UIColor(named: "mainGray")!
        }
        
        static var statusLabelFont: UIFont {
            UIFont.systemFont(ofSize: 14)
        }

    }
    
    var onLogout: (() -> Void)?
    var onSelectSortOptions: (() -> Void)?
    
    let viewModel: ServerListViewModelProtocol
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        view.register(ServerListTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        view.contentInset = Constants.tableViewContentInset
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .white
        return view
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sort", for: .normal)
        button.titleLabel?.font = Constants.sortButtonFont
        button.setImage(UIImage(named: "ico-sort-light"), for: .normal)
        button.tintColor = Constants.sortButtonTintColor
        button.backgroundColor = Constants.sortButtonBgColor
        button.imageEdgeInsets.right = 8
        button.addTarget(self, action: #selector(didSelectSortButton), for: .touchUpInside)
        return button
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.statusLabelColor
        label.textAlignment = .center
        label.font = Constants.statusLabelFont
        return label
    }()
    
    init(viewModel: ServerListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        
        viewModel.load(sortBy: .name)
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(
            image: UIImage(named: "ico-logout"),
            style: .done,
            target: self,
            action: #selector(didSelectLogoutButton)
        )
        navigationItem.rightBarButtonItem = button
        button.tintColor = Constants.logoutButtonColor
        
        let view = ServerListLogoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = view
    }
    
    @objc func didSelectLogoutButton() {
        viewModel.logout()
    }
    
    @objc func didSelectSortButton() {
        onSelectSortOptions?()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let sortButtonContainer = UIView()
        sortButtonContainer.backgroundColor = Constants.sortButtonBgColor
        sortButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButtonContainer)
        sortButtonContainer.addSubview(sortButton)
        
        let headerView = ServerListHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sortButton.topAnchor),
            
            sortButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sortButton.leadingAnchor.constraint(equalTo: sortButtonContainer.leadingAnchor),
            sortButton.topAnchor.constraint(equalTo: sortButtonContainer.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: sortButtonContainer.trailingAnchor),
            sortButton.bottomAnchor.constraint(equalTo: sortButtonContainer.safeAreaLayoutGuide.bottomAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: Constants.sortButtonHeight),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func displayError(error: String) {
        statusLabel.text = error
        statusLabel.isHidden = false
        tableView.isHidden = true
    }
    
    func displayResult() {
        statusLabel.text = nil
        statusLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func didSelectSortOption(_ option: ServerItemLocalRepositorySortOption) {
        viewModel.load(sortBy: option)
    }
}

extension ServerListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ServerListTableViewCell
        let item = viewModel.items[indexPath.row]
        item.populate(cell: cell)
        
        return cell
    }
}

extension ServerListController: UITableViewDelegate {}

extension ServerListController: ServerListViewModelDelegate {
    func didLoadItems() {
        displayResult()
    }
    
    func didReceiveError(error: String) {
        displayError(error: error)
    }
    
    func didLogout() {
        onLogout?()
    }
}
