//
//  ServerListFetchLoadingView.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListFetchLoadingView: UIImageView {
    
    enum Constants {
        static var animationDuration: CFTimeInterval {
            2
        }
        
        static var color: UIColor {
            .white
        }
    }
    
    init() {
        super.init(image: UIImage(named: "loader"))
        tintColor = Constants.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = CGFloat.pi * 2
        animation.toValue = 0
        animation.isRemovedOnCompletion = false
        animation.duration = Constants.animationDuration
        animation.repeatCount = .infinity
        layer.add(animation, forKey: nil)
    }

    public func stopAnimation() {
        layer.removeAllAnimations()
    }
}
