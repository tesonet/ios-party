//
//  ServersListViewController.swift
//  Testio
//
//  Created by Julius on 12/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit
import RealmSwift

class ServersListViewController: ViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortViewTopConstraint: NSLayoutConstraint!
    
    fileprivate let repository = ServersRepository()
    fileprivate var servers: Results<ServerModel>?
    fileprivate var notificationToken: NotificationToken? = nil
    fileprivate var sortBy: String? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadData()
        
        let sortViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSortViewTap(_:)))
        sortView.addGestureRecognizer(sortViewTapRecognizer)
        
        navigationBar.delegate = self
    }
    
    @objc func onSortViewTap(_ sender: Any) {
        let sortMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let byDistanceAction = UIAlertAction(title: "By Distance", style: .default, handler: { [weak self] (action) -> Void in
            self?.sortBy = "distance"
            self?.sortViewTopConstraint.constant = -44
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        })
        sortMenu.addAction(byDistanceAction)
        
        let alphanumericalAction = UIAlertAction(title: "Alphanumerical", style: .default, handler: { [weak self] (action) -> Void in
            self?.sortBy = "name"
            self?.sortViewTopConstraint.constant = -44
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        })
        sortMenu.addAction(alphanumericalAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) -> Void in
            self?.sortViewTopConstraint.constant = -44
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        })
        
        sortMenu.addAction(cancelAction)
        
        sortViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        
        self.present(sortMenu, animated: true, completion: nil)
    }
    
    func setupTable() {
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = UIColor.grayColor
        
        var contentInset = table.contentInset
        contentInset.bottom += 44
        table.contentInset = contentInset
        
        let serverTableViewCellNib = UINib(nibName: "ServerTableViewCell", bundle: nil)
        table.register(serverTableViewCellNib, forCellReuseIdentifier: ServerTableViewCell.identifier)
    }
    
    func loadData() {
        servers = repository.getAllServers(sortBy: sortBy)
        
        notificationToken?.invalidate()
        notificationToken = servers?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.table.reloadData()
            case .update(_, _, _, _):
                self?.table.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension ServersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ServerTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ServersListSectionHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ServersListSectionHeaderView.height
    }
}

extension ServersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.identifier) as? ServerTableViewCell else {
            return UITableViewCell()
        }
        
        guard let servers = servers else {
            return UITableViewCell()
        }
        
        guard servers.count > indexPath.row else {
            return UITableViewCell()
        }
        
        cell.setServer(servers[indexPath.row])
    
        return cell
    }
}

extension ServersListViewController: NavigationBarDelegate {
    func onRightButtonTap() {
        AuthManager.shared.logout()
        Router.navigate(.login)
    }
}
