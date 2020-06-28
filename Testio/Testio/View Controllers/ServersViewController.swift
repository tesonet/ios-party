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
    private let tableView = UITableView()
    
    convenience init(servers: [Server])
    {
        self.init()
        self.servers = servers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    @objc func sort()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortDistanceAction = UIAlertAction(title: "By Distance", style: .default)
        {
            [weak self] UIAlertAction in
            let sortDescriptor = NSSortDescriptor.init(key: "distance", ascending: true)
            self!.servers = CoreDataManager.shared.getServers(sortDescriptor: sortDescriptor)
            self!.tableView.reloadData()
        }
        let sortNameAction = UIAlertAction(title: "Alphanumerical", style: .default)
        {
            [weak self] UIAlertAction in
            let sortDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
            self!.servers = CoreDataManager.shared.getServers(sortDescriptor: sortDescriptor)
            self!.tableView.reloadData()
            
        }
        
        alert.addAction(sortDistanceAction)
        alert.addAction(sortNameAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func logout()
    {
        print("did tap on logout")
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
        tableView.register(ServersViewTableViewCell.self, forCellReuseIdentifier:Constants.ServersViewTableViewCellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 50.0
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.9)
        tableView.sectionHeaderHeight = 70.0
        
        let testioImageView = UIImageView.init(image: UIImage.init(named: "LogoDark"))
        testioImageView.contentMode = .scaleAspectFit
        testioImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(testioImageView)
        testioImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        testioImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        testioImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        testioImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        let logoutImage = UIImageView.init(image: UIImage.init(named: "Logout"))
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        logoutImage.contentMode = .scaleAspectFit
        logoutImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logout))
        logoutImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(logoutImage)
        logoutImage.bottomAnchor.constraint(equalTo: testioImageView.bottomAnchor).isActive = true
        logoutImage.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        logoutImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        logoutImage.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //sorting button
        let sortingButton = UIButton(type:.custom)
        sortingButton.setTitle("Sort", for: .normal)
        sortingButton.tintColor = .white
        sortingButton.backgroundColor = UIColor.init(red: 65/255, green: 69/255, blue: 97/255, alpha: 0.95)
        sortingButton.addTarget(self, action: #selector(sort), for: .touchDown)
        sortingButton.setImage(UIImage.init(named: "Sort"), for: .normal)
        sortingButton.imageView?.contentMode = .scaleAspectFill
        sortingButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        sortingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sortingButton)
        sortingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:0.0).isActive = true
        sortingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:0.0).isActive = true
        sortingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0).isActive = true
        sortingButton.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: testioImageView.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sortingButton.topAnchor, constant: 0).isActive = true
    }
}
