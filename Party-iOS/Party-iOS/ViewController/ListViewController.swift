//
//  ListViewController.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

final class ListViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ServerTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(named: "ico-logout"), style: .plain, target: self, action: #selector(logoutAction))
    }()
    
    private lazy var titleItem: UIBarButtonItem = {
        UIBarButtonItem(customView: UIImageView(image: UIImage(named: "logo-dark")))
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Sort", for: .normal)
        button.setImage(UIImage(named: "ico-sort-light"), for: .normal)
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    var servers: [Server]? = ListStorage.load()
    
    lazy var dataSource: ListDataSource = ListDataSource(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        tableView.dataSource = dataSource
        dataSource.update()
    }
    
    private func showErrorAlert(_ error: APIClientError) {
        let message: String = {
            if case .networkError(let networkError) = error,
               case .http(let httpError, _) = networkError,
               case .unauthorized = httpError {
                return "Username or Password is incorrect"
            } else {
                return "Network error occured."
            }
        }()
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    @objc func logoutAction(_ sender :Any) {#imageLiteral(resourceName: "simulator_screenshot_6963BBDF-4D5B-460C-B975-E2490DFC5EF3.png")
        AuthenticationStorage.shared.clearData()
        coordinator?.navigate(.login)
    }
    
    @objc func sortAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "By Distance", style: .default, handler: { [weak self] (action) in
            self?.dataSource.sort(by: .distance)
            self?.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Alphanumerical", style: .default, handler: { [weak self] (action) in
            self?.dataSource.sort(by: .alphanumerical)
            self?.tableView.reloadData()
        }))
        present(alertController, animated: true)
    }
}

extension ListViewController {
    
    private func setupUI() {
        view.backgroundColor = PartyColor.lightGray
        tableView.backgroundColor = PartyColor.lightGray
        navigationController?.navigationBar.barTintColor = PartyColor.lightGray
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = titleItem
    }
    
    private func setupLayout() {
        [tableView, buttonBackground, sortButton].forEach { view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sortButton.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonBackground.leadingAnchor.constraint(equalTo: sortButton.leadingAnchor),
            buttonBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonBackground.trailingAnchor.constraint(equalTo: sortButton.trailingAnchor),
            buttonBackground.topAnchor.constraint(equalTo: sortButton.topAnchor),
            
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        ServerHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

extension ListViewController: ListDataSourceDelegate {
    func dataSourceDidUpdate(error: APIClientError?) {
        if let error = error {
            showErrorAlert(error)
        } else {
            tableView.reloadData()
        }
    }
}
