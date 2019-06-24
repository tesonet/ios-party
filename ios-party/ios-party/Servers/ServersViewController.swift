import UIKit

protocol ServersViewControllerDelegate: class {
    
    func didLogout(in viewController: ServersViewController)
}

final class ServersViewController: UIViewController {
    
    private let serversResponse: ServersResponse
    
    private lazy var serversView: ServersView = {
        let viewModel = ServersViewModel(response: serversResponse)
        let view = ServersView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: ServersViewControllerDelegate?
    
    init(serversResponse: ServersResponse) {
        self.serversResponse = serversResponse
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupView()
    }
    
    private func setupView() {
        serversView.delegate = self
        serversView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(serversView)
        NSLayoutConstraint.fill(view: view, with: serversView)
    }
    
    private func handleLogout() {
        dismiss(animated: true, completion: nil)
        delegate?.didLogout(in: self)
    }
}

extension ServersViewController: ServersViewDelegate {
    
    func logoutTapped(in viewController: ServersView) {
        handleLogout()
    }
}
