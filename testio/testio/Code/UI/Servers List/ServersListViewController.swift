//
//  ServersListViewController.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit
import CoreData

protocol ServersListViewControllerDelegate: class {
    func serverListViewControllerDidSelectLogout(_ view: ServersListViewController)
}

class ServersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    weak var delegate: ServersListViewControllerDelegate?
    
    private let persistenceStore: PersistenceStore
    
    private let headerView: HeaderView
    private let tableView: UITableView
    private let serverCellIdentifier = "ServerCellIdentifier"
    
    private var fetchedResultsController: NSFetchedResultsController<Server>?
    private let distanceFormatter: MeasurementFormatter
    
    private let sortButtonContainer: UIView
    private let sortButton: UIButton
    private var sortOrder = SortOrder.name {
        didSet {
            self.makeFetchedResultsController(using: sortOrder)
        }
    }
    
    init(persistenceStore: PersistenceStore) {
        self.persistenceStore = persistenceStore
        
        self.headerView = HeaderView()
        
        self.tableView = UITableView()
    
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(ServerCell.self, forCellReuseIdentifier: self.serverCellIdentifier)
        
        self.distanceFormatter = MeasurementFormatter()
        self.distanceFormatter.unitOptions = .providedUnit
        
        self.sortButtonContainer = UIView()
        
        self.sortButtonContainer.alpha = 0.5
        self.sortButtonContainer.backgroundColor = UIColor.blue
        
        self.sortButton = UIButton()
        self.sortButton.setTitle(NSLocalizedString("Sort", comment: ""), for: .normal)
        self.sortButton.setImage(UIImage(named: "ico-sort-light"), for: .normal)
        
        self.sortButtonContainer.addSubview(self.sortButton)
        
        super.init(nibName: nil, bundle: nil)
        
        self.sortButton.addTarget(self, action: #selector(self.sort(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
        
        self.headerView.preservesSuperviewLayoutMargins = true
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tableView)
        
        self.view.addSubview(self.sortButtonContainer)
        
        self.makeNavigationItems()
        self.makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 55, 0)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.makeFetchedResultsController()
    }
    
    private func makeNavigationItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "logo-dark"),
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico-logout"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.logout(_:)))
    }
    
    private func makeConstraints() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.sortButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.sortButtonContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.sortButtonContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.sortButtonContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.sortButton.leadingAnchor.constraint(equalTo: self.sortButtonContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.sortButton.trailingAnchor.constraint(equalTo: self.sortButtonContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.sortButton.topAnchor.constraint(equalTo: self.sortButtonContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        self.sortButton.bottomAnchor.constraint(equalTo: self.sortButtonContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.sortButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    private func makeFetchedResultsController(using sortOrder: SortOrder = .name) {
        let fetchRequest = Server.serverFetchRequest()
        
        switch sortOrder {
        case .name:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        case .distance:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        }
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: self.persistenceStore.viewContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
        
        self.fetchedResultsController?.delegate = self
        
        try? self.fetchedResultsController?.performFetch()
        
        self.tableView.reloadData()
    }
    
    @objc private func logout(_ sender: Any?) {
        self.delegate?.serverListViewControllerDidSelectLogout(self)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.serverCellIdentifier, for: indexPath) as! ServerCell
        
        let server = self.fetchedResultsController!.object(at: indexPath)
        
        cell.name = server.name
        
        let measurement = Measurement(value: server.distance, unit: UnitLength.meters)
        cell.distance = self.distanceFormatter.string(from: measurement)
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    // MARK: - Sort
    
    @objc private func sort(_ sender: Any?) {
        self.sortOrder = self.sortOrder == .name ? .distance : .name
    }
}

extension ServersListViewController {
    enum SortOrder {
        case name
        case distance
    }
}
