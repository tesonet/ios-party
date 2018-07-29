//
//  AppFlowAnimator.swift
//  Testio
//
//  Created by Mindaugas on 29/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class AppFlowAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval = 0.4
    var isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
            return
        }

        if isPresenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }

        let fromFrame = fromView.frame
        let toFrame = toView.frame
        
        let toViewXCoordinateValue = isPresenting ? toFrame.width : -toFrame.width
        toView.frame = CGRect(x: toViewXCoordinateValue,
                              y: 0,
                              width: toFrame.width,
                              height: toFrame.height)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                let fromViewXCoordinateValue = self.isPresenting ? -fromFrame.width : fromFrame.width
                fromView.frame = CGRect(x: fromViewXCoordinateValue,
                                        y: 0,
                                        width: fromFrame.width,
                                        height: fromFrame.height)
                toView.frame = fromFrame
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    

}
