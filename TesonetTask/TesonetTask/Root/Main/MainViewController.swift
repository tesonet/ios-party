//
//  MainViewController.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainController {
    
    enum SortType {
        case distance
        case alphanumerically
    }
    
    let networkManager = MainNetworkManager()
    let authManager = Bindings.shared.authManager
    var loadingViewModel: MainLoadingViewModel?
    var servers = [ServersResponse]()
    private let footerHeight: CGFloat = 60.0
    
    lazy var tableManager: TableViewManager = {
        let tm = TableViewManager()
        tm.tableView.backgroundColor = .clear
        tm.tableView.separatorStyle = .singleLine
        tm.tableView.estimatedRowHeight = 50
        tm.tableView.separatorStyle = .none
        tm.deselectCellsOnClick = true
        return tm
    }()
    
    var type: MainControllerType
    
    init() {
        type = .main
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let rgb: CGFloat = 240.0 / 255.0
        view.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
        createNavBarRightButton()
        
        doLayout()
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        guard let loadingViewModel = loadingViewModel else {
            self.loadingViewModel = MainLoadingViewModel()
            setupLoadingView()
            return
        }
        
        view.add(model: loadingViewModel)
    }
    
    private func createNavBarRightButton() {
        let logoutImg = UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal)
        let logoutButton = UIBarButtonItem(image: logoutImg, style: .plain, target: self, action: #selector(logoutAction))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logoutAction() {
        authManager.cleanHeaders()
        getRootController().changeRoot(type: .auth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchServers()
    }
    
    override var inputAccessoryView: UIView? {
        let footer = MainFooterView.instantiateFromXib()
        footer.delegate = self
        footer.frame = CGRect(x: 0, y: 0, width: 0, height: footerHeight)
        return footer
    }
    
    override var canBecomeFirstResponder: Bool {
        return !servers.isEmpty
    }
    
    private func doLayout() {
        guard let tableView = tableManager.tableView else { return }

        tableManager.tableViewController.willMove(toParent: self)
        addChild(tableManager.tableViewController)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -footerHeight)
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableManager.tableViewController.didMove(toParent: self)
    }
    
    private func fetchServers() {
        networkManager.fetchServers { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let response):
                strongSelf.handleServersResponse(servers: response)
            case .failure(let error):
                ShowWarning.showWarningWithString(error.localizedDescription)
            }
        }
    }
    
    private func handleServersResponse(servers: [ServersResponse]) {
        self.servers = servers
        
        if let loadingViewlModel = loadingViewModel {
            UIView.animate(withDuration: 0.2, animations: {
                loadingViewlModel.view?.alpha = 0.0
            }) { [weak self] (_)  in
                guard let strongSelf = self else {
                    return
                }
                
                loadingViewlModel.view?.removeFromSuperview()
                strongSelf.loadingViewModel = nil
                strongSelf.fadeTableView()
            }
        }
        
        
        setupServersSection(servers: servers)
        becomeFirstResponder()
    }
    
    private func fadeTableView() {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        tableManager.tableView.layer.add(transition, forKey: "FadeAnimation")
    }
    
    private func setupServersSection(servers: [ServersResponse]) {
        let items = servers.compactMap { return ServelCellItem(server: $0) }
        let sectionModel = ServerSectionModel()
        tableManager.addSections([TableSection(items: items, sectionModel: sectionModel)])
        tableManager.tableView.reloadData()
    }
    
    private func sortServersBy(type: SortType) {
        var sortedServers: [ServersResponse]
        
        switch type {
        case .distance:
            sortedServers = servers.sorted { $0.distance > $1.distance }
        case .alphanumerically:
            sortedServers = servers.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
        
        fadeTableView()
        tableManager.sections.removeAll()
        setupServersSection(servers: sortedServers)
    }
}

extension MainViewController: MainFooterViewDelegate {
    func sortAction() {
        let controller = AlertBuilder.chooseSortOption(distance: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.sortServersBy(type: .distance)
        }) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.sortServersBy(type: .alphanumerically)
        }
        
        present(controller, animated: true, completion: nil)
    }
}
