//
//  RootViewController.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol RootController {
    func changeRoot(type: MainControllerType)
}

protocol MainController {
    var type: MainControllerType { get set }
}

class RootViewController: UIViewController {
    
    var isTransitionInProgress = false
    var fadeDuration: Double { return 0.3 }
    
    var initialType: MainControllerType {
        return Bindings.shared.authManager.isLoggedIn() ? .main : .auth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        changeRoot(type: initialType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setupNewMainController(_ type: MainControllerType, completion: CompletionAction? = nil) {
        let controller = type.controller
        
        
        controller.view.layoutIfNeeded()
        controller.view.alpha = 0.0
        let navController = UINavigationController(rootViewController: controller)
        
        addChildController(navController)
        
        if let completion = completion {
            controller.view.fadeIn(duration: fadeDuration, completionAction: completion)
        } else {
            controller.view.fadeIn(duration: fadeDuration, completionAction: nil)
        }
    }
    
    fileprivate func handleTransitionAnimation(_ oldController: UIViewController,
                                               type: MainControllerType,
                                               completion: CompletionAction? = nil) {
        let completionBlock: CompletionAction = { finished in
            oldController.removeFromParrentController()
            self.setupNewMainController(type, completion: completion)
        }
        oldController.view.fadeOut(duration: fadeDuration, completionAction: completionBlock)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension RootViewController: RootController {
    
    func changeRoot(type: MainControllerType) {
        guard isTransitionInProgress == false else { return }
        isTransitionInProgress = true
        
        view.resignFirstResponder()
        view.endEditing(true)
        
        guard let existingRootController = children.first?.children.first else {
            setupNewMainController(type) { [weak self] (_) in
                self?.isTransitionInProgress = false
            }
            return
        }
        
        guard let prevController = existingRootController as? MainController else {
            fatalError("something went wrong")
        }
        
        guard prevController.type != type else {
            isTransitionInProgress = false
            return
        }
        
        handleTransitionAnimation(existingRootController, type: type) { [weak self] (_) in
            self?.isTransitionInProgress = false
        }
    }
    
}
