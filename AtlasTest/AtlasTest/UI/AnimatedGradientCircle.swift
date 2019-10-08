//
//  AnimatedGradientCircle.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 10/4/19.
//  Copyright © 2019 krokus. All rights reserved.
//
// Solution found at: https://stackoverflow.com/questions/40188058/how-to-draw-a-circle-path-with-color-gradient-stroke
import Foundation
import UIKit

@IBDesignable
class GradientArcView: UIView {
    @IBInspectable var startColor: UIColor = .white { didSet { setNeedsLayout() } }
    @IBInspectable var endColor:   UIColor = .blue  { didSet { setNeedsLayout() } }
    @IBInspectable var lineWidth:  CGFloat = 6.0 { didSet { setNeedsLayout() } }

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.byValue = NSNumber(value: 2*M_PI as Double)
        rotation.duration = 1
        rotation.repeatCount = Float.infinity
        gradientLayer.add(rotation, forKey: "lineRotation")
    }
}

private extension GradientArcView {
    func configure() {
        layer.addSublayer(gradientLayer)
    }

    func updateGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor, endColor].map { $0.cgColor }
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = lineWidth
        mask.path = path.cgPath
        gradientLayer.mask = mask
    }
}
