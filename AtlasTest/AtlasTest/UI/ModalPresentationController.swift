//
//  ModalPresentationController.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
protocol LayoutObserver {
    func layoutDidChange()
}

// MARK: - VC that should be notified on dismiss transition start
protocol DismissableByTap {
    func dismissByTap()
}

// MARK: - VC whose layout changes we want to observe
protocol LayoutObservable {
    var layoutObserver: LayoutObserver? { get set }
}

// MARK: - presentation controller observing the dynamic layout changes of presented VC
class ModalPresentationController: UIPresentationController, LayoutObserver {

    lazy var dimmingView: UIView = UIView()
    var observable: LayoutObservable?

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        observable = presentedViewController as? LayoutObservable
        observable?.layoutObserver = self
        setupDimmingView()
        
        //Tap gesture recognizer for dismissal
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.cancelsTouchesInView = false
        dimmingView.addGestureRecognizer(tapRecognizer)
    }

    override func containerViewWillLayoutSubviews() {
        if self.containerView == nil { return }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        guard let container = self.containerView else { return }
        dimmingView.frame = container.bounds
        containerView?.insertSubview(dimmingView, at: 0)
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.5
            }, completion: nil)
        } else {
            dimmingView.alpha = 0.5
        }
    }

    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 0.0
        }
    }
    
    // MARK: - Notify presented dialog that it has been dismissed by tap
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        // Make sure it's not a tap on the dialog but the background
        let point = sender.location(in: presentedViewController.view)
        guard !presentedViewController.view.point(inside: point, with: nil) else { return }
        if let dismissableByTap = presentedViewController as? DismissableByTap {
            dismissableByTap.dismissByTap()
        }
    }

    // MARK: - methods responsible for creating and animating the dimming view
    func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.white
        dimmingView.alpha = 0.0
    }

    // MARK: - methods responsible for sizing of presented view controller
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            var presentedViewFrame = presentedViewController.view.bounds
            guard let containerBounds = containerView?.bounds else { return presentedViewFrame }
            presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
            presentedViewFrame.origin.x = (containerBounds.size.width - presentedViewFrame.size.width) / 2
            presentedViewFrame.origin.y = (containerBounds.size.height - presentedViewFrame.size.height) / 2
            return presentedViewFrame
        }
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return container.preferredContentSize
    }

    func layoutDidChange() {
        if self.containerView == nil { return }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
