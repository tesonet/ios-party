// Created by Paulius Cesekas on 02/04/2019.

import UIKit
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

class ServerListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private(set) weak var tableView: UITableView!

    // MARK: - Variables
    private var fetchServers: BehaviorRelay<Void>!
    private var sortServers: PublishSubject<ServerSort>!
    private var logout: PublishSubject<Void>!
    private var viewModel: ServerListViewModel!
    private let disposeBag = DisposeBag()
    private(set) var tableViewDataSource: ServerListTableDataSource!
    private var input: ServerListViewModel.Input!
    private var output: ServerListViewModel.Output!
    private lazy var loadingViewController: LoadingViewController = {
        return LoadingViewController(state: L10n.Login.loading)
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(onNext: { [unowned self] (_) in
                self.fetchServers.accept(())
            })
            .disposed(by: disposeBag)
        return refreshControl
    }()

    // MARK: - Methods -
    class func initialiaze(with viewModel: ServerListViewModel) -> ServerListViewController {
        let viewController = StoryboardScene.Servers
            .serverListViewController
            .instantiate()
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
    }

    // MARK: - Configure
    private func configure() {
        guard viewModel != nil else {
            fatalError("`viewModel` is not set")
        }

        configureTableView()
        configureRX()
    }

    private func configureTableView() {
        tableViewDataSource = ServerListTableDataSource(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.backgroundColor = UIColor.secondary
        tableView.addSubview(refreshControl)
    }

    private func configureRX() {
        fetchServers = BehaviorRelay(value: ())
        sortServers = PublishSubject()
        logout = PublishSubject()
        input = ServerListViewModel.Input(
            fetchServers: fetchServers.asDriverOnErrorJustComplete(),
            sortServers: sortServers.asDriverOnErrorJustComplete(),
            logout: logout.asDriverOnErrorJustComplete())
        output = viewModel.transform(input: input)
        bindOutput(output)
    }

    // MARK: - Setup
    private func setupUI() {
        title = L10n.ServerList.title
        view.backgroundColor = UIColor.secondary
        tableView.backgroundColor = UIColor.secondary
        setupNavigationBar()
        setupLoading()
    }
    
    private func setupNavigationBar() {
        navigationController?.applyDefaultStyle()
        navigationController?.addButton(
            with: Asset.logoDark.image,
            to: .left,
            target: self,
            action: #selector(didTouchUpInsideLogoButton))
        navigationController?.addButton(
            with: Asset.icoLogout.image,
            to: .right,
            target: self,
            action: #selector(didTouchUpInsideLogoutButton))
    }

    private func setupLoading() {
        updateLoadingState(true)
    }
    
    // MARK: - Rx Binding
    func bindOutput(_ output: ServerListViewModel.Output) {
        bindIsLoading(output.isLoading)
        bindError(output.error)
        bindServers(output.servers)
    }

    private func bindIsLoading(_ isLoading: Driver<Bool>) {
        isLoading
            .drive(onNext: { [unowned self] (isLoading) in
                self.updateLoadingState(isLoading)
            })
            .disposed(by: disposeBag)
    }

    private func bindError(_ error: Driver<Error>) {
        error
            .drive(onNext: { [unowned self] (error) in
                self.handleError(error)
            })
            .disposed(by: disposeBag)
    }

    private func bindServers(_ servers: Driver<[Server]>) {
        servers
            .drive(onNext: { [unowned self] (servers) in
                self.updateServers(servers)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UI Actions
    @objc
    private func didTouchUpInsideLogoButton() {
        print("didTouchUpInsideLogoButton()")
    }
    
    @objc
    private func didTouchUpInsideLogoutButton() {
        logout.onNext(())
    }

    // MARK: - Helpers
    private func updateLoadingState(_ isLoading: Bool) {
        guard isLoading else {
            hideLoading()
            return
        }

        tableView.backgroundView = nil
        showLoading(animated: true)
    }

    private func handleError(_ error: Error) {
        print(error.localizedDescription)
        tableView.backgroundView = ErrorStateView()
    }
    
    private func updateServers(_ servers: [Server]) {
        tableViewDataSource.servers = servers
        tableView.reloadData()
    }

    private func showLoading(animated: Bool) {
        if let presentedViewController = presentedViewController as? LoadingViewController {
            loadingViewController = presentedViewController
        }
        loadingViewController.updateState(L10n.ServerList.loading)
        guard !loadingViewController.isBeingPresented else {
            return
        }
        
        present(
            loadingViewController,
            animated: animated)
    }

    private func hideLoading() {
        refreshControl.endRefreshing()
        UIView.animate(withDuration: Constants.animationDuration) {
            self.tableView.contentOffset = .zero
        }
        loadingViewController.dismiss(animated: true)
    }
}
