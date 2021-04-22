//
//  AnimatorViewController.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 21.04.2021.
//

import UIKit

class TransitionAnimator: NSObject {
    fileprivate var isPresenting = true
    fileprivate var snapshotView: UIView?
}

extension TransitionAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TransitionAnimatorConfig.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else { return }
        if isPresenting {
            
            self.snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            if let fromVCSnapshot = self.snapshotView {
                fromVC.view.addSubview(fromVCSnapshot)
            }
            
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
 
            UIView.animate(withDuration: TransitionAnimatorConfig.duration) {
                toVC.view.alpha = 1
                fromVC.view.transform = CGAffineTransform(scaleX: TransitionAnimatorConfig.animationScale, y: TransitionAnimatorConfig.animationScale)
            } completion: { (done) in
                if done {
                    transitionContext.completeTransition(true)
                    fromVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.snapshotView?.removeFromSuperview()
                    self.snapshotView = nil
                }
            }
        } else {
            UIView.animate(withDuration: TransitionAnimatorConfig.duration) {
                fromVC.view.alpha = 0
            } completion: { (done) in
                transitionContext.completeTransition(true)
                fromVC.view.removeFromSuperview()
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
