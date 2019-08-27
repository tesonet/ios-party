import UIKit
import User
import UserInterface

final class AppFlowCoordinator: NSObject {
    
    static let shared = AppFlowCoordinator()
    private var navigationController: UINavigationController!
    private var authenticationCoordinator: AuthenticationCoordinator?
    private var serversCoordinator: ServersListCoordinator?
    
    private lazy var navigationVC: NavigationVC = {
        let vc = NavigationVC()
        vc.delegate = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return vc
    }()
    
    func start(in window: UIWindow) {
        let vc: UIViewController? = {
            if User().info == nil {
                return setupLogin()
            } else {
                return setupContentContainer()
            }
        }()
        
        guard let rootVC = vc else { return }
        
        rootVC.view.translatesAutoresizingMaskIntoConstraints = true
        navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.view.translatesAutoresizingMaskIntoConstraints = true
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

//MARK: - LOGIN
extension AppFlowCoordinator: AuthenticationCoordinatorDelegate {

    private func setupLogin() -> UIViewController? {
        authenticationCoordinator = AuthenticationCoordinator()
        authenticationCoordinator?.delegate = self
        return authenticationCoordinator?.viewController
    }
    
    func auhtenticationCompleted() {
        let containerVC = setupContentContainer()
        navigationController.show(containerVC, sender: self)
        navigationController.viewControllers.remove(at: 0)
        authenticationCoordinator = nil
    }
}


//MARK: - LIST
extension AppFlowCoordinator {
    
    private func setupContentContainer() -> UIViewController {
        
        let containerVC: UIViewController = {
            let vc = UIViewController()
            vc.view.translatesAutoresizingMaskIntoConstraints = true
            vc.view.backgroundColor = UIColor.Testio.gray
            
            vc.addChild(navigationVC)
            vc.view.addSubview(navigationVC.view)
            NSLayoutConstraint.activate([
                navigationVC.view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                navigationVC.view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                navigationVC.view.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor)
                ])
            navigationVC.didMove(toParent: vc)
            
            guard let listVC = setupList() else { return vc }
            listVC.view.translatesAutoresizingMaskIntoConstraints = false
            vc.addChild(listVC)
            vc.view.addSubview(listVC.view)
            NSLayoutConstraint.activate([
                listVC.view.topAnchor.constraint(equalTo: navigationVC.view.bottomAnchor),
                listVC.view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                listVC.view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                listVC.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
                ])
            listVC.didMove(toParent: vc)
            return vc
        }()
        
        serversCoordinator?.start()
        return containerVC
    }
    
    private func setupList() -> UIViewController? {
        serversCoordinator = ServersListCoordinator()
        return serversCoordinator?.viewController
    }
}

//MARK: - NAVIGATION
extension AppFlowCoordinator: NavigationVCActionResponder {
    
    func navigationVCDidSelectLogout() {
        User().deleteAll()
        guard let loginVC = setupLogin() else { return }
        navigationController.viewControllers.insert(loginVC, at: 0)
        navigationController.popViewController(animated: true)
        serversCoordinator = nil
    }
}
