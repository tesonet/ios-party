//
//  SpinnerView.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

@IBDesignable
class SpinnerView: UIView {
    @IBInspectable var startColor: UIColor = .white { didSet { setNeedsLayout() } }
    @IBInspectable var endColor:   UIColor = .clear  { didSet { setNeedsLayout() } }
    @IBInspectable var lineWidth:  CGFloat = 3      { didSet { setNeedsLayout() } }
    static let kRotationAnimationKey = "rotationanimationkey"
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
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
}

private extension SpinnerView {
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
