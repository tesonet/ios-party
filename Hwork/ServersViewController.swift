//
//  ServersViewController.swift
//  Hwork
//
//  Created by Robert P. on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

class ServersViewController: UIViewController {
    
    enum SortType:String {
        case name
        case distance
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var servers: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var gradientBtm: UIView!
    
    lazy var fetchedResultController: NSFetchedResultsController<Server> = {
        
        let fetchRequest: NSFetchRequest<Server> = Server.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceManager.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ServerTableViewCell", bundle: nil), forCellReuseIdentifier: Const.Cells.serverCellIdentifier)
        let headerNib = UINib.init(nibName: "HeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: Const.Cells.headerCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        getServers()
        fetch(sort: .name)
        addRefreshEnteredFromBackgroundNotif()
        adjustFonts()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addGradient(gradView: gradientBtm)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        
        performLogout()
    }
    
    @IBAction func sortAction(_ sender: UIButton) {
        
        showActionSheet()
    }
    
    func adjustFonts() {
        
        let font = UIFont(name: "Roboto-Light", size: 11.0 * Const.sizeMultiplyer)
        servers.font = font
        distance.font = font
    }
    
    func fetch(sort: SortType) {
        
        fetchedResultController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: sort.rawValue, ascending: true)]
        do {
            try self.fetchedResultController.performFetch()
            tableView.reloadData()
        } catch  {
            self.showAlert(text: Const.Response.ErrorStatus.other.rawValue, dismissHandler: {
                self.performLogout()
            })
        }
    }
    
    func getServers() {
        
        DataSynchronizer.shared.updateServers { (error) in
            LoaderController.shared.hide()
            if let err = error {
                self.showAlert(text: err.rawValue, dismissHandler: {
                    self.performLogout()
                })
            }
        }
    }
    
    func performLogout() {
        
        
        DataSynchronizer.shared.deleteAllData()
        _ = KeychainWrapper.standard.removeAllKeys()
        dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet() {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let distanceAction = UIAlertAction(title: "By Distance", style: .default , handler: { (action) -> Void in
            self.fetch(sort: .distance)
        })
        let nameAction = UIAlertAction(title: "Alphanumerical", style: .default , handler: { (action) -> Void in
            self.fetch(sort: .name)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(distanceAction)
        optionMenu.addAction(nameAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func addRefreshEnteredFromBackgroundNotif() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        
            LoaderController.shared.show()
            self.getServers()
            self.fetch(sort: .name)
    }
   
    func addGradient(gradView: UIView) {
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = gradView.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 1]
        gradView.layer.mask = gradientMaskLayer
        
    }
    
}




extension ServersViewController:UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let count = fetchedResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.Cells.serverCellIdentifier, for: indexPath) as! ServerTableViewCell
        if let server = fetchedResultController.object(at: indexPath) as Server? {
            
            cell.configCell(name: server.name!, distance: server.distance)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40 *  Const.sizeMultiplyer
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
}
