//
//  ViewExtension.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

public extension UIView {

    fileprivate func fadeAnimation(_ fadeValue: CGFloat,
                                   duration: Double,
                                   options: UIView.AnimationOptions,
                                   completionAction: CompletionAction) {
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            self.alpha = fadeValue
            
        }, completion: completionAction)
    }

    internal func fadeIn(duration: Double, completionAction: CompletionAction) {
        fadeAnimation(1.0, duration: duration, options: .curveEaseIn, completionAction: completionAction)
    }

    internal func fadeOut(duration: Double, completionAction: CompletionAction) {
        fadeAnimation(0.0, duration: duration, options: .curveEaseOut, completionAction: completionAction)
    }

    //view hierarchy extension
    func viewContainingController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }

    func topMostController() -> UIViewController? {
        
        var controllersHierarchy = [UIViewController]()
        
        if var topController = window?.rootViewController {
            controllersHierarchy.append(topController)
            
            while let presented = topController.presentedViewController {
                
                topController = presented
                
                controllersHierarchy.append(presented)
            }
            
            var matchController: UIResponder? = viewContainingController()
            
            while matchController != nil && controllersHierarchy.contains(matchController as! UIViewController) == false {
                
                repeat {
                    matchController = matchController?.next
                    
                } while matchController != nil && matchController is UIViewController == false
            }
            
            return matchController as? UIViewController
            
        } else {
            return viewContainingController()
        }
    }
    
}
