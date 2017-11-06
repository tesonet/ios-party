//
//  UIWindow+Utils.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

extension UIWindow {
	
	final class var keyWindow: UIWindow? {
		return UIApplication.shared.keyWindow
	}
	
	/// Returns topmost visible view controller.
	///
	/// - Returns: topmost visible view controller.
	final class func visibleViewController() -> UIViewController? {
		return keyWindow?.visibleViewController()
	}
	
	/// Returns topmost view controller in receiver.
	///
	/// - Returns: topmost view controller in receiver.
	final func visibleViewController() -> UIViewController? {
		return visibleViewController(from: rootViewController)
	}
	
	private func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
		
		if let navigationController = viewController as? UINavigationController {
			
			return visibleViewController(from: navigationController.topViewController)
			
		} else if let tabBarController = viewController as? UITabBarController {
			
			return visibleViewController(from: tabBarController.selectedViewController)
			
		} else if let viewController = viewController {
			
			if let presentedViewController = viewController.presentedViewController {
				
				if presentedViewController is UIAlertController {
					return viewController
				} else {
					return visibleViewController(from: presentedViewController)
				}
				
			} else {
				
				return viewController
				
			}
			
		} else {
			
			return .none
			
		}
		
	}
	
	/// Updates root view controller for the window with transition animation.
	///
	/// - Parameters:
	///   - newRootViewController: New root view controller for the window..
	///   - transition: The animation to be used during transition process.
	/// Can be `nil`. If `nil`, then `CATransition` with `kCATransitionFade` type is used.
	final func set(
		rootViewController newRootViewController: UIViewController,
		with transition: CATransition? = .none)
	{
		
		let previousViewController = rootViewController
		
		let transition = transition ?? {
			let transition = CATransition()
			transition.type = kCATransitionFade
			return transition
			}()
		layer.add(transition, forKey: kCATransition)
		
		rootViewController = newRootViewController
		
		if let transitionViewClass = NSClassFromString("UITransitionView") {
			for subview in subviews where subview.isKind(of: transitionViewClass) {
				subview.removeFromSuperview()
			}
		}
		
		if let previousViewController = previousViewController {
			previousViewController.dismiss(animated: false) { [weak previousViewController] in
				previousViewController?.view.removeFromSuperview()
			}
		}
		
	}
	
}
