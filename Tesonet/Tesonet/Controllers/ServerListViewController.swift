//
//  ServerListViewController.swift
//  Tesonet
//

import UIKit

class ServerListViewController: UIViewController {

    @IBOutlet private weak var serversTableView: UITableView!
    @IBOutlet private weak var serverNameLabel: UILabel!
    @IBOutlet private weak var distanceToServerLabel: UILabel!

    private var serverList: [ServerModel] = []

    private lazy var sortAlert: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "SortByDistance".localized, style: .default, handler: { [weak self] (action) in
            guard let self = self else {
                return
            }
            self.serverList = self.serverList.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.distanceToServer >= rhs.distanceToServer
            })
            self.serversTableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "SortByAlphaNumeric".localized, style: .default, handler: { [weak self] (action) in
            guard let self = self else {
                return
            }
            self.serverList = self.serverList.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.serverName.caseInsensitiveCompare(rhs.serverName) == .orderedAscending
            })
            self.serversTableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alertController
    }()

    static func instantiate(with serverList: [ServerModel]) -> ServerListViewController {
        let vc = UIStoryboard(.main).instantiateViewController(for: ServerListViewController.self)
        vc.serverList = serverList
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        serversTableView.delegate = self
        serversTableView.dataSource = self
        serversTableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func didClickSort(_ sender: UIButton) {
        self.present(sortAlert, animated: true)
    }

    @IBAction func didClickLogout(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: -
}

// MARK: - TableView Methods

extension ServerListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellClass: ServerCell.self)
        cell.model = serverList[indexPath.row]
        return cell
    }
}

extension ServerListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: -
