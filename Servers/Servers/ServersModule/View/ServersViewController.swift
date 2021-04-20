//
//  ServersViewController.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

class ServersViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet private weak var sortButton: ServerSortButton!
    @IBOutlet private weak var logoutButton: BaseButton!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLeftLabel: UILabel!
    @IBOutlet private weak var titleRightLabel: UILabel!

    var presenter: ServersPresenterProtocol! = nil

    private let cellReuseIdentifier = "ServerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.getServersFromBackend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTitleView()
        setupButtons()        
    }
    
    private func setupButtons() {
        sortButton.didTap = { [weak self] in
            self?.presenter.sort()
        }
        
        logoutButton.didTap = { [weak self] in
            self?.presenter.logOut()
        }
    }
    
    private func setupTitleView() {
        titleLeftLabel.text = ServerConstants.titleView.labels.leftLabelText.uppercased()
        titleRightLabel.text = ServerConstants.titleView.labels.rightLabelText.uppercased()
        
        titleRightLabel.textColor = ServerConstants.titleView.labels.textColor
        titleLeftLabel.textColor = ServerConstants.titleView.labels.textColor
        
        titleView.layer.shadowColor = ServerConstants.titleView.shadowColor.cgColor
        titleView.layer.shadowOffset = ServerConstants.titleView.shadowOffset
        titleView.layer.shadowRadius = ServerConstants.titleView.shadowRadius
        titleView.layer.shadowOpacity = ServerConstants.titleView.shadowOpacity
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ServerCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension ServersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ServerCell else {
            fatalError("No ServerCell")
        }
        cell.update(with: presenter.servers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ServersViewController: ServersViewProtocol {
    
    func showSortingMenu(options: [String]) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        options.forEach({
            alertVC.addAction(UIAlertAction(title: $0, style: .default) { [weak self] (action) in
                self?.presenter.didSelect(option: action.title ?? "")
                alertVC.dismiss(animated: true, completion: nil)
            })
        })
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        
        present(alertVC, animated: true, completion: nil)
    }

    func reloadUI() {
        tableView.reloadData()
    }
    
    func show(error: Error) {
        present(error: error)
    }
}
