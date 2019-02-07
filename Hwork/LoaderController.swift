//
//  LoaderController.swift
//  Hwork
//
//  Created by Robertas Pauzas on 05/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit

final class LoaderController {
    
    static let shared = LoaderController()
    private init() {}
    private var coveringWindow: UIWindow?
    var circle:UIView?  {
        return coveringWindow?.rootViewController?.view.viewWithTag(Const.spinnerViewTag)
    }
    
    func show() {
        
        let fr = UIApplication.shared.keyWindow?.frame
        coveringWindow = UIWindow(frame: (fr)!)
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Loader") as UIViewController
        coveringWindow!.rootViewController = viewController
        coveringWindow!.windowLevel = UIWindow.Level.alert + 1
        coveringWindow?.alpha = 0.0
        coveringWindow!.makeKeyAndVisible()
        animateTransition(show: true)
        spin()
    }
    
    func hide() {
        
        animateTransition(show: false)
    }
    
    private func animateTransition(show: Bool) {
        
        var alpha:CGFloat = 1.0
        if !show {
            alpha = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.coveringWindow?.alpha = alpha
        }) { (finished) in
            if !show {
                self.coveringWindow = nil
            }
        }
    }
    
    private func spin() {
       
        if let spinner = circle {
            let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = Double.pi * 2
            rotation.duration = 0.75
            rotation.isCumulative = true
            rotation.repeatCount = Float.greatestFiniteMagnitude
            spinner.layer.add(rotation, forKey: "rotationAnimation")
        }
    }
}
