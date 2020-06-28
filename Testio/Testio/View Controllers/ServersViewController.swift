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
        print("did click on sort")
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
        tableView.sectionHeaderHeight = 70.0
        
        let testioImageView = UIImageView.init(image: UIImage.init(named: "LogoDark"))
        testioImageView.clipsToBounds = true
        testioImageView.contentMode = .scaleAspectFit
        testioImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(testioImageView)
        testioImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        testioImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        testioImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        testioImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        let logoutButton = UIButton.init(type:.custom)
        
        
        //sorting button
        let sortingButton = UIButton(type:.custom)
        sortingButton.setTitle("Sort", for: .normal)
        sortingButton.tintColor = .white
        sortingButton.backgroundColor = UIColor.init(red: 70/255, green: 75/255, blue: 100/255, alpha: 0.95)
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
    }
}
