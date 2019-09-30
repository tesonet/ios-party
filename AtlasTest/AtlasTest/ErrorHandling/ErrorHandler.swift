//
//  ErrorHandler.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorHandlerDelegate: AnyObject {
    func onError(_ error: AppError)
}

class ErrorHandler {
    static var processedError: AppError?
    unowned var dependency: DependencyContainer?

    init(dependency: DependencyContainer?) {
        self.dependency = dependency
    }
    
    // MARK: - checks if the top view is error alert
    func isErrorDisplayed() -> Bool {
        return ErrorHandler.processedError != nil
    }
   
   func processFatalError(error: AppError) {
        ErrorHandler.processedError = error
        if error.severity == .fatal {
            dependency?.flowStateProcessor?.appFlowState = .onFatalError
            return
        }
    }

    // MARK: - display error handler view controller
    func process(error: AppError, inWindow: Bool = false, completionHandler:(() -> Void)?) {
        guard ErrorHandler.processedError == nil else { return }
        ErrorHandler.processedError = error

        if error.severity == .fatal {
            dependency?.flowStateProcessor?.appFlowState = .onFatalError
            return
        }
        guard let errorHandlerVC = makeErrorViewController(error: error) else { return }
        errorHandlerVC.onDone = {
           ErrorHandler.processedError = nil
           if error.name == "authError" {
            self.dependency?.flowStateProcessor?.appFlowState = .undefined
           }
        }
        if error.severity == .fatal {
            dependency?.window?.rootViewController = errorHandlerVC
            processFatalError(error: error) //clean state perhaps?
            return
        }
        
        if inWindow {
            presentViewControllerFromAlertWindow(viewControllerToPresent: errorHandlerVC, animated: true)
            return
        }
        presentViewControllerFromVisibleViewController(errorHandlerVC, animated: true)
    }

    func makeErrorViewController(error: AppError) -> ErrorHandlerViewController? {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardId: String =  "ERROR_HANDLER"
        guard let errorHandlerVC = mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as? ErrorHandlerViewController else { return nil }
        errorHandlerVC.onError(error)
        return errorHandlerVC
    }

    func presentViewControllerFromVisibleViewController(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil) {
        var rootViewController = dependency?.window?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.custom
        viewControllerToPresent.transitioningDelegate = viewControllerToPresent as? UIViewControllerTransitioningDelegate
        rootViewController?.definesPresentationContext = true
        rootViewController?.present(viewControllerToPresent, animated: true) {
             rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }

    func presentViewControllerFromAlertWindow( viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.rootViewController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.custom
        viewControllerToPresent.transitioningDelegate = viewControllerToPresent as? UIViewControllerTransitioningDelegate
        alertWindow.rootViewController?.definesPresentationContext = true
        alertWindow.rootViewController?.present(viewControllerToPresent, animated: true, completion: nil)
    }

}
