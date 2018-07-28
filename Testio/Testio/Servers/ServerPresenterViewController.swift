//
//  ServerPresenterViewController.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ServerPresenterViewController: UIViewController, BindableType {
    
    typealias ViewModelType = ServerPresenterViewModel
    
    private var disposeBag = DisposeBag()
    
    var viewModel: ViewModelType
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var headerView: UIView!
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    func bindViewModel() {
        viewModel.serverResults.drive(tableView.rx.items) { (tableView: UITableView, index: Int, element: TestioServer) in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.reuseIdentifier, for: indexPath)

            guard let serverCell = cell as? ServerTableViewCell else {
                return cell
            }
            serverCell.update(withLeftLabelText: element.name, rightLabelText: "\(element.distance)")
            return serverCell
        }
        .disposed(by: disposeBag)
    }
    
}

extension ServerPresenterViewController {
    
    private func setupAppearance() {
        headerView.backgroundColor = Colors.backgroundColor
        view.backgroundColor = Colors.backgroundColor

        setupTableViewAppearance()
        setupTableViewHeader()
        setupSortView()
    }
    
    private func setupSortView() {
        let sortView = SortSelectionView()
        view.addSubview(sortView)
        sortView.addConstraints()
    }
    
    private func setupTableViewAppearance()  {
        tableView.allowsSelection = false
        tableView.register(ServerTableViewCell.self, forCellReuseIdentifier: ServerTableViewCell.reuseIdentifier)
        tableView.separatorColor = .gray
        tableView.contentInset = UIEdgeInsetsMake(0, 0, SortSelectionView.defaultHeight, 0)
    }

    private func setupTableViewHeader() {
        let header = ServersTableViewHeader()
        tableView.tableHeaderView = header
        header.addConstraints()
        
        let leftLabelText = NSLocalizedString("SERVER_NAME", comment: "").uppercased()
        let rightLabelText = NSLocalizedString("SERVER_DISTANCE", comment: "").uppercased()
        header.update(withLeftLabelText: leftLabelText,
                      rightLabelText: rightLabelText)
    }
    
}
