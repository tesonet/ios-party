//
//  LoadingView.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 16.04.2021.
//

import UIKit

class LoadingView: UIView {
    
    private let lineWidth: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = true
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func startAnimation() {
        animationLayer.removeFromSuperlayer()
        
        animationLayer.frame = bounds
        layer.addSublayer(animationLayer)
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = -2 * CGFloat.pi
        rotation.duration = 0.7
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotation.repeatCount = Float(Int.max)
        rotation.isRemovedOnCompletion = false
            
        animationLayer.add(rotation, forKey: nil)
    }
    
    func stopAnimation() {
        self.animationLayer.removeFromSuperlayer()
        
    }
    
    private lazy var animationLayer: CALayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.type = .conic
        
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(white: 1, alpha: 0.5), UIColor(white: 1, alpha: 0.1)]
        gradientLayer.startPoint = CGPoint(x: 0.15, y: 0.15)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2), radius: self.bounds.width / 2 - 2 * lineWidth, startAngle: -1.5, endAngle: 6, clockwise: true)
        maskLayer.path = path.cgPath
        maskLayer.lineWidth = lineWidth
        
        gradientLayer.mask = maskLayer
        return gradientLayer
    }()
}
