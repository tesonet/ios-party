//
//  ServersViewController.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/26/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class ServersViewController: UIViewController {
    
    private var servers:[Server]?
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(ServersViewTableViewCell.self, forCellReuseIdentifier:Constants.ServersViewTableViewCellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 50.0
        tableView.bounces = false
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.8)
        tableView.sectionHeaderHeight = 70.0
        return tableView
    }()
    
    private let testioImageView:UIImageView = {
        let testioImageView = UIImageView.init(image: UIImage.init(named: "LogoDark"))
        testioImageView.contentMode = .scaleAspectFit
        testioImageView.translatesAutoresizingMaskIntoConstraints = false
        return testioImageView
    }()
    
    private let logoutImage:UIImageView = {
        let logoutImage = UIImageView.init(image: UIImage.init(named: "Logout"))
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        logoutImage.contentMode = .scaleAspectFit
        logoutImage.isUserInteractionEnabled = true
        return logoutImage
    }()
    
    private let sortingButton:UIButton = {
        let sortingButton = UIButton(type:.custom)
        sortingButton.setTitle("Sort", for: .normal)
        sortingButton.tintColor = .white
        sortingButton.backgroundColor = UIColor.init(red: 65/255, green: 69/255, blue: 97/255, alpha: 1.0)
        sortingButton.addTarget(self, action: #selector(sort), for: .touchDown)
        sortingButton.setImage(UIImage.init(named: "Sort"), for: .normal)
        sortingButton.imageView?.contentMode = .scaleAspectFill
        sortingButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        sortingButton.translatesAutoresizingMaskIntoConstraints = false
        return sortingButton
    }()
        
    private let headerView:TableViewHeaderView = {
        let headerView = TableViewHeaderView()
        headerView.setup()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private var sortAlertController:UIAlertController?
    private var logoutAlertController:UIAlertController?
    
    convenience init(servers: [Server])
    {
        self.init()
        self.servers = servers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func sort()
    {
        if let alert = sortAlertController {
            present(alert, animated: true, completion: nil)
            return
        }
        let sortDistanceAction = UIAlertAction(title: "By Distance", style: .default)
         {
             [weak self] UIAlertAction in
             guard let self = self else {
                 return
             }
             self.servers = self.servers?.sorted(by: {$0.distance < $1.distance})
             self.tableView.reloadData()
         }
         let sortNameAction = UIAlertAction(title: "Alphanumerical", style: .default)
         {
             [weak self] UIAlertAction in
             guard let self = self else {
                 return
             }
            self.servers = self.servers?.sorted(by: {$0.name!.compare($1.name!, options: NSString.CompareOptions.caseInsensitive) == ComparisonResult.orderedAscending})
             self.tableView.reloadData()
         }
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         {
             UIAlertAction in
         }
        let actions = [cancelAction, sortNameAction, sortDistanceAction]
        let alert = self.createAlert(title: nil, message: nil, actions: actions)
        sortAlertController = alert
        present(alert, animated: true, completion: nil)
    }
    @objc func logout()
    {
        if let alert = logoutAlertController {
            present(alert, animated: true, completion: nil)
            return
        }
        let keepCredentialsAction = UIAlertAction(title: "Keep And Logout", style: .default)
        {
            [weak self] UIAlertAction in
            guard let self = self else {
                return
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        let deleteCredentialsAction = UIAlertAction(title: "Delete And Logout", style: .default)
        {
            [weak self] UIAlertAction in
            guard let self = self else {
                return
            }
            KeychainManager.deleteCredentialsForKey(CredentialsKey.password)
            KeychainManager.deleteCredentialsForKey(CredentialsKey.username)
            KeychainManager.deleteCredentialsForKey(CredentialsKey.token)
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            UIAlertAction in
        }
        let actions = [cancelAction, keepCredentialsAction, deleteCredentialsAction]
        
        let alert = self.createAlert(title: nil, message: "Do you want to delete your saved credentials?", actions: actions)
        logoutAlertController = alert
        present(alert, animated: true, completion: nil)
    }
    
    private func createAlert(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions
        {
            alert.addAction(action)
        }
        
        return alert
    }
}

extension ServersViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.servers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ServersViewTableViewCell = tableView.dequeueReusableCell(withIdentifier:Constants.ServersViewTableViewCellID) as! ServersViewTableViewCell
        guard let cellServer = servers?[indexPath.row] else {
            return cell
        }
        cell.server = cellServer
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
}

extension ServersViewController
{
    
    func setupUI()
    {
        self.view.backgroundColor = .white
        
        setupImages()
        setupHeader()
        setupButton()
        setupTableView()
    }
    
    private func setupImages()
    {
        view.addSubview(testioImageView)
        testioImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        testioImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        testioImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        testioImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logout))
        logoutImage.addGestureRecognizer(gestureRecognizer)
        view.addSubview(logoutImage)
        logoutImage.bottomAnchor.constraint(equalTo: testioImageView.bottomAnchor).isActive = true
        logoutImage.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        logoutImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        logoutImage.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    private func setupHeader()
    {
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: testioImageView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
    
    private func setupTableView()
    {
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sortingButton.topAnchor, constant: 0).isActive = true
    }
    
    private func setupButton(){
        view.addSubview(sortingButton)
        sortingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:0.0).isActive = true
        sortingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:0.0).isActive = true
        sortingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0).isActive = true
        sortingButton.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
}
