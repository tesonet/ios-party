// Created by Paulius Cesekas on 02/04/2019.

import UIKit

extension UIView {
    // MARK: - Constants
    private static let rotationAnimationKey = "rotationAnimationKey"
    
    // MARK: - Methods -
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.rotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            layer.add(rotationAnimation, forKey: UIView.rotationAnimationKey)
        }
    }
    
    func stopRotating() {
        guard layer.animation(forKey: UIView.rotationAnimationKey) == nil else {
            return
        }

        layer.removeAnimation(forKey: UIView.rotationAnimationKey)
    }
}
