//
//  Transition.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 10/1/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case left
    case right
    case up
    case down
}
// MARK: - change root vc in window
class Transition {
    static func changeRootViewController(with targetViewController: UIViewController, in window: UIWindow, direction: Direction) {
        guard let storyboard = window.rootViewController?.storyboard else { return }
        guard let snapshotView = window.snapshotView(afterScreenUpdates: true) else { return }
        let fromViewImage = snapshotView.toImage()
        let toViewImage = targetViewController.view.toImage()
        
        let fromLayer = CALayer()
        fromLayer.bounds = window.bounds
        fromLayer.bounds.origin = CGPoint(x: 0.0, y: 0.0)
        fromLayer.contents = fromViewImage.cgImage
        fromLayer.contentsGravity = .center
        fromLayer.frame.origin = CGPoint(x: 0.0, y: 0.0)
        targetViewController.view.layer.addSublayer(fromLayer)
        
        let toLayer = CALayer()
        toLayer.bounds = window.bounds
        toLayer.bounds.origin = CGPoint(x: 0.0, y: 0.0)
        toLayer.contents = toViewImage.cgImage
        toLayer.contentsGravity = .center
        switch direction {
        case .down: toLayer.frame.origin = CGPoint(x: 0.0, y: -toLayer.bounds.height)
        case .up: toLayer.frame.origin = CGPoint(x: 0.0, y: toLayer.bounds.height)
        case .left: toLayer.frame.origin = CGPoint(x: 0.0, y: toLayer.bounds.width)
        case .right: toLayer.frame.origin = CGPoint(x: 0.0, y: -toLayer.bounds.width)
        }
        targetViewController.view.layer.addSublayer(toLayer)
        window.rootViewController = targetViewController
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            switch direction {
            case .down:
                fromLayer.frame.origin = CGPoint(x: 0.0, y: fromLayer.bounds.height)
            case .up:
                fromLayer.frame.origin = CGPoint(x: 0.0, y: -fromLayer.bounds.height)
            case .left:
                fromLayer.frame.origin = CGPoint(x: -fromLayer.bounds.width, y: 0.0)
            case .right:
                fromLayer.frame.origin = CGPoint(x: fromLayer.bounds.width, y: 0.0)
            }
            toLayer.frame.origin = CGPoint(x: 0.0, y: 0.0)
            targetViewController.view.layoutIfNeeded()
        }){ _ in
            fromLayer.removeFromSuperlayer()
            toLayer.removeFromSuperlayer()
        }
    }
}

extension UIView {
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: false) }
    }
}

