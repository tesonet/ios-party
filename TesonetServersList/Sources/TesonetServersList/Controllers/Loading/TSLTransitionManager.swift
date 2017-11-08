//
//  TSLTransitionManager.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/8/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

final class TSLTransitionManager: NSObject {
	
	private var isPresenting: Bool = false
	
}

// MARK: - UIViewControllerAnimatedTransitioning

extension TSLTransitionManager: UIViewControllerAnimatedTransitioning {
	
	final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let container = transitionContext.containerView
		let fromView: UIView = transitionContext.view(forKey: .from)! // swiftlint:disable:this force_unwrapping
		let toView: UIView = transitionContext.view(forKey: .to)! // swiftlint:disable:this force_unwrapping
		
		let offScreenRight: CGAffineTransform = CGAffineTransform(rotationAngle: -.pi / 2.0)
		
		let offScreenLeft: CGAffineTransform = CGAffineTransform(rotationAngle: .pi / 2.0)
		
		// prepare the toView for the animation
		toView.transform = self.isPresenting ? offScreenLeft : offScreenRight
		
		toView.layer.anchorPoint = .zero
		fromView.layer.anchorPoint = .zero
		
		toView.layer.position = .zero
		fromView.layer.position = .zero
		
		container.addSubview(toView)
		container.addSubview(fromView)
		
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0.0,
			usingSpringWithDamping: 0.8,
			initialSpringVelocity: 1.5,
			options: [],
			animations: { [unowned self] in
				
				fromView.transform = self.isPresenting ? offScreenRight : offScreenLeft
				toView.transform = .identity
				
			},
			completion: { (_) in
				
				transitionContext.completeTransition(true)
				
		})
		
	}
	
	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?)
		-> TimeInterval
	{
		return 1.25
	}
	
}
// MARK: - UIViewControllerTransitioningDelegate
extension TSLTransitionManager: UIViewControllerTransitioningDelegate {
	
	final func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController)
		-> UIViewControllerAnimatedTransitioning?
	{
		self.isPresenting = true
		return self
	}
	
	final func animationController(
		forDismissed dismissed: UIViewController)
		-> UIViewControllerAnimatedTransitioning?
	{
		self.isPresenting = false
		return self
	}
	
}
