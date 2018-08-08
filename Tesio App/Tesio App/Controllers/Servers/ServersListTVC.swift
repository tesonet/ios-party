//
//  ServersListTVC.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/26/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit
import Foundation

private extension Selector {
    static let logoutPressed = #selector(ServersListTVC.logoutPressed)
    static let sortPressed = #selector(ServersListTVC.sortPressed)
}

class ServersListTVC: UITableViewController {
    
    // MARK: Enums
    private enum Strings {
        static let logoutIconName = "logoutIcon"
        static let logoImageName = "logoDark"
        static let serverCellIdentifier = "serverCellIdentifier"
        static let headerViewNibName = "HeaderView"
        static let sortViewNibName = "SortView"
    }

    // MARK: Vars
    var servers: [Server] = []
    var headerView: HeaderView = {
        if let view_ = Bundle.main.loadNibNamed(Strings.headerViewNibName, owner: self, options: nil)?.first as? HeaderView {
            view_.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0)
            view_.backgroundView.addShadow()
            return view_
        }
        return HeaderView()
    }()
    var sortView: SortView = {
        if let view_ = Bundle.main.loadNibNamed(Strings.sortViewNibName, owner: self, options: nil)?.first as? SortView {
            view_.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: TesioHelper.sortViewHeight)
            return view_
        }
        return SortView()
    }()
    // Create counter to animate cell once
    var counterForCellAnimation: Int = 0
    var isLoginPresented: Bool = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        setupNavigationBar()
        setupSortView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if TesioHelper.isAuthorized {
            if let savedServers = TesioHelper.getServersList(), savedServers.count > 0 {
                servers = savedServers
                if !isLoginPresented {
                    refresh()
                }
            }
        }
        else {
            hideSortView()
            presentLoginVC()
        }
    }

    
    // MARK: - Methods
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Strings.logoutIconName)?.withRenderingMode(.alwaysOriginal),
                                           style: .plain, target: self,
                                           action: .logoutPressed)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: Strings.logoImageName)?.withRenderingMode(.alwaysOriginal),
                                           style: .plain, target: self,
                                           action: nil)
    }
    
    func setupSortView() {
        navigationController?.view.addSubview(sortView)
        // Adjust "Sort" text & icon to better fit iPhoneX
        if TesioHelper().currentDevice() == .iPhoneX { sortView.centerYConstraint.constant = -15 }
        sortView.sortButton.addTarget(self, action: .sortPressed, for: .touchUpInside)
        // Present view with animation
        UIView.animate(withDuration: 0.3, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
            self.sortView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - TesioHelper.sortViewHeight + 20.0,
                                         width: UIScreen.main.bounds.size.width, height: TesioHelper.sortViewHeight)
        }, completion: nil)
    }
    
    func presentLoginVC() {
        if let loginVC = UIStoryboard(name: "Main",
                                      bundle: nil).instantiateViewController(withIdentifier: TesioHelper.Constant.Identifiers.login) as? LoginVC {
            loginVC.onLoginCompletion = { servers in
                self.isLoginPresented = true
                if let servers = servers {
                    self.servers = servers
                    self.showSortView()
                    self.dismiss(animated: true, completion: {
                        self.refresh()
                    })
                }
            }
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @objc func logoutPressed() {
        TesioHelper.cleanOnLogout()
        presentLoginVC()
    }
    
    @objc func sortPressed() {
        print("Sort pressed!")
        hideSortView()
        showActionSheet()
    }
    
    
}

// MARK: - Extension for TableView Methods/Actions
extension ServersListTVC {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ServerCell = tableView.dequeueReusableCell(withIdentifier: Strings.serverCellIdentifier) as? ServerCell else {
            return UITableViewCell()
        }

        cell.serverNameLabel.text = servers[indexPath.row].name
        cell.distanceLabel.text = "\(servers[indexPath.row].distance)"
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    // MARK: - Methods
    func refresh() {
        tableView.reloadData(with: .simple(duration: 0.5, direction: .top(useCellsFrame: true), constantDelay: 0.0))
        // TODO: - Dismis loading indicator?
    }
    
}

// MARK: - Extension for SortView Methods/Actions
extension ServersListTVC {
    func showSortView() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.sortView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - TesioHelper.sortViewHeight + 20.0,
                                          width: UIScreen.main.bounds.size.width, height: TesioHelper.sortViewHeight) }, completion: nil)
    }
    
    func hideSortView() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.sortView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height,
                                          width: UIScreen.main.bounds.size.width, height: TesioHelper.sortViewHeight) }, completion: nil)
    }
    
    func showActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = TesioHelper.Constant.Color.mainDarkBlue
        
        let sortByDistanceAction = UIAlertAction(title: "By Distance", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortByDistance()
            self.showSortView()
            self.refresh()
        })
        let sortAlphanumericalAction = UIAlertAction(title: "Alphanumerical", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortAlphanumerically()
            self.showSortView()
            self.refresh()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showSortView()
        })
        
        optionMenu.addAction(sortByDistanceAction)
        optionMenu.addAction(sortAlphanumericalAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func sortByDistance() {
        servers.sort(by: { $0.distance < $1.distance })
    }
    
    func sortAlphanumerically() {
        servers.sort(by: { $0.name.compare($1.name, options: .numeric) == .orderedAscending })
    }
}

















