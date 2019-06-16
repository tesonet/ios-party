import UIKit

final class ServersViewController: UIViewController {
    
    private lazy var serversView: ServersView = {
        let view = ServersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(serversResponse: ServersResponse) {
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
        let serversView = ServersView()
        serversView.delegate = self
        serversView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(serversView)
        NSLayoutConstraint.fill(view: view, with: serversView)
    }
    
    @objc private func logoutTapped() {
        fatalError("logout not implemented")
    }
}

extension ServersViewController: ServersViewDelegate {
    
    func logoutTapped(in viewController: ServersView) {
        fatalError("logout not implemented")
    }
}

