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
