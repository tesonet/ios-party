//
//  LoadingActivityView.swift
//  Testio
//
//  Created by Andrii Popov on 3/9/21.
//

import UIKit

class LoadingActivityView: UIView, XibInstantiable {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    lazy var activityLayer: CALayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: ServersListConstants.activityIndicator.geometry.diameter,
                                     height: ServersListConstants.activityIndicator.geometry.diameter)
        gradientLayer.type = .conic
        gradientLayer.colors = [UIColor.white.cgColor,
                                UIColor(white: 1.0, alpha: 0.6).cgColor,
                                UIColor(white: 1.0, alpha: 0.4).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = gradientLayer.bounds
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: ServersListConstants.activityIndicator.geometry.diameter / 2,
                                                         y: ServersListConstants.activityIndicator.geometry.diameter / 2),
                                      radius: ServersListConstants.activityIndicator.geometry.diameter / 2 - 2 * ServersListConstants.activityIndicator.geometry.lineWidth,
                                      startAngle: -1.5,
                                      endAngle: 6,
                                      clockwise: true)
        maskLayer.path = bezierPath.cgPath
        maskLayer.lineWidth = ServersListConstants.activityIndicator.geometry.lineWidth
        
        gradientLayer.mask = maskLayer
        return gradientLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(activityLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityLayer.position = self.center
    }
    
    func updateMessage(_ messageText: String) {
        messageLabel.text = messageText
    }
    
    func animate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = -2 * CGFloat.pi
        rotationAnimation.duration = 1.5
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotationAnimation.repeatCount = Float(Int.max)
        rotationAnimation.isRemovedOnCompletion = false
        activityLayer.add(rotationAnimation, forKey: nil)
    }
    
    func hide() {
        UIView.animate(withDuration: ServersListConstants.defaultAnimationDuration , delay: 0, options: .curveEaseInOut) {
            self.alpha = 0.0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
}
