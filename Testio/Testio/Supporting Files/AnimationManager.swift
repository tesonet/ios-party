//
//  AnimationManager.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class AnimationManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popStyle: Bool = false
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        tz.view.frame = fz.view.frame
        tz.view.alpha = 0.0
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.alpha = 1.0
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
}
