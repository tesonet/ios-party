//
//  LoadingViewController.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

enum IndicatorType {
    case circle
}

class LoadingViewController: UIViewController, UIViewControllerTransitioningDelegate, LayoutObservable, DismissableByTap  {
    @IBOutlet private weak var rotatingCircleView: GradientArcView!
    static private var currentViewController: LoadingViewController?
    static private var presenter: UIViewController?
    var completionHandler: (() -> Void)?
    let horizontalMargin: CGFloat = 30.0
    var layoutObserver: LayoutObserver?
    var onDone: (() -> Void)?
    var onCancel: (() -> Void)?
    
    static func makeLoadingViewController(indicatorType: IndicatorType = .circle, completionHandler: (() -> Void)? = nil) -> LoadingViewController? {
        guard let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LOADING") as? LoadingViewController else {
            return nil
        }
        newViewController.completionHandler = completionHandler
        return newViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LoadingViewController.presenter != nil {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rotatingCircleView.rotate()
        view.updateConstraints()
        if LoadingViewController.presenter != nil {
            view.layer.cornerRadius = 16.0
            view.layer.masksToBounds = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rotatingCircleView.isHidden = true
    }
    
    // MARK: - Presenting View Controller modally
    static func present(from parentViewController: UIViewController, animated flag: Bool, onCancel: (() -> Void)? = nil) {
        LoadingViewController.presenter = parentViewController
        guard currentViewController == nil else { return }
        guard let viewController = LoadingViewController.makeLoadingViewController(completionHandler: nil) else { return }
        viewController.onCancel = onCancel
        currentViewController = viewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.custom
        viewController.transitioningDelegate = viewController as UIViewControllerTransitioningDelegate
        parentViewController.definesPresentationContext = true
        // Allow for dialog dismissal on background tap
        parentViewController.present(viewController, animated: true, completion: nil)
        parentViewController.setNeedsStatusBarAppearanceUpdate()
    }
    
    static func tryToDismiss(with completionHandler: (() -> Void)? = nil) {
        if let completion = completionHandler {
            currentViewController?.dismiss(animated: true) {
                presenter?.setNeedsStatusBarAppearanceUpdate()
                currentViewController = nil
                presenter = nil
                completion()
            }
            return
        }
        currentViewController?.dismiss(animated: true) {
            presenter?.setNeedsStatusBarAppearanceUpdate()
            currentViewController = nil
            presenter = nil
        }
    }
    
    func dismissByTap() {
        if LoadingViewController.presenter != nil {
            LoadingViewController.tryToDismiss(with: onCancel)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setTransparentBg() {
        view.backgroundColor = UIColor.clear
    }
    
    @objc public override var preferredContentSize: CGSize {
        get {
            //width is constant
            if LoadingViewController.presenter == nil {
                let contentWidth = UIScreen.main.bounds.width
                let contentHeight = UIScreen.main.bounds.height
                return CGSize(width: contentWidth, height: contentHeight)
            } else {
                let contentWidth = CGFloat(UIScreen.main.bounds.width - 2 * 32.0)
                let contentHeight = CGFloat(320.0)
                return CGSize(width: contentWidth, height: contentHeight)
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    // MARK: - Transitioning delegate methods
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presented)
    }
}
