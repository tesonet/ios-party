//
//  LoadingView.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 08/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var spinnerImage: UIImageView!
    
    static let shared = {
        Bundle.main.loadNibNamed(#function, owner: nil, options: nil)?[0] as? LoadingView
    }()
    
    var minimumAnimationDuration: TimeInterval = 0.8
    private var animationStarted: TimeInterval = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func start() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        animationStarted = Date().timeIntervalSinceNow // allow updating animation start
        
        if !window.subviews.contains(self) {
            window.addSubview(self)
            frame = window.bounds
            alpha = 0
            
            animateSpinner()
            UIView.animate(withDuration: Const.standardAnimationDuration) {[weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func stop() {
        let durationLeft = animationStarted + minimumAnimationDuration
        
        UIView.animate(withDuration: Const.standardAnimationDuration, delay: max(0, durationLeft), animations: {[weak self] in
            self?.alpha = 0
            }, completion: {[weak self] (_) in
                self?.removeFromSuperview()
                self?.spinnerImage.layer.removeAllAnimations()
        })
    }
    
    private func animateSpinner() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.valueFunction = CAValueFunction(name: .rotateZ)
        animation.fromValue = 0
        animation.toValue = Float.pi * 2
        animation.duration = 1.2
        animation.repeatCount = .infinity
        spinnerImage.layer.add(animation, forKey: "spinAnimation")
    }
}
