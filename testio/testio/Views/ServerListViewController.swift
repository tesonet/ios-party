//
//  ServerListViewController.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 04/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit
import CoreData

class ServerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderShadowView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    
    private var serverFetchController: NSFetchedResultsController<Server>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData(sortBy: ServerResult.CodingKeys.name.rawValue)
    }
    
    private func setup() {
        sortButton.setTitle(Strings.ServerListVC.sortButtonTitle.localized, for: .normal)
        tableHeaderShadowView.layer.shadowColor = #colorLiteral(red: 0.02745098039, green: 0.1490196078, blue: 0.2196078431, alpha: 1)
        tableHeaderShadowView.layer.shadowOpacity = 0.3
        tableHeaderShadowView.layer.shadowRadius = 15
    }

    // MARK: - Actions
    
    @IBAction func doSort() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Strings.Cancel.localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Strings.ServerListVC.sortByDistance.localized, style: .default, handler: {[weak self] (_) in
            self?.fetchData(sortBy: ServerResult.CodingKeys.distance.rawValue)
        }))
        alert.addAction(UIAlertAction(title: Strings.ServerListVC.sortAlphanumerical.localized, style: .default, handler: {[weak self] (_) in
            self?.fetchData(sortBy: ServerResult.CodingKeys.name.rawValue)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doLogOut() {
        Notification.logOut.post()
    }
    
    // MARK: - Private methods
    
    private func fetchData(sortBy: String) {
        if let controller = serverFetchController {
            PersistentContainer.shared.updateFetch(sortBy: sortBy, for: controller)
        } else {
            serverFetchController = PersistentContainer.shared.fetch(withRequest: Server.fetchRequest(), sortBy: sortBy)
            serverFetchController?.delegate = self
        }
        
        // Updating table view with animation.
        tableView.reloadSections([0], with: .automatic)
    }
    
    deinit {
        serverFetchController = nil
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ServerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.cellID) as? ServerTableViewCell,
              let server = serverFetchController?.object(at: indexPath)
        else {
            return UITableViewCell()
        }
        cell.configureCell(for: server)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return serverFetchController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverFetchController?.sections?[section].numberOfObjects ?? 0
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ServerListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ServerTableViewCell,
                  let server = controller.object(at: indexPath) as? Server
            else { return }
            cell.configureCell(for: server)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
