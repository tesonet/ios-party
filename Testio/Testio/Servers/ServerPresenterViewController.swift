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
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func bindViewModel() {
        
        viewModel.serverResults.drive(tableView.rx.items) { (tableView: UITableView, index: Int, element: TestioServer) in
            let cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: nil)
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = "\(element.distance)"
            return cell
        }
        .disposed(by: disposeBag)
    }
    
}
