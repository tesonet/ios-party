//
//  LoadingViewController.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import RxSwift

final class LoadingViewController: UIViewController {
    
    @IBOutlet private var loadingTextLabel: UILabel!
    @IBOutlet private var loadingIndicatorImageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    var loadingStatusText: String? {
        set {
            loadingTextLabel.text = newValue
        }
        get {
            return loadingTextLabel.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingTextLabel.textColor = .white
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startIndicatorAnimation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopIndicatorAnimation()
    }

}

extension LoadingViewController {
    
    private func startIndicatorAnimation() {
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = -(Double.pi * 2)
        rotation.duration = 3
        rotation.repeatCount = .infinity
        loadingIndicatorImageView.layer.add(rotation, forKey: nil)
    }
    
    private func stopIndicatorAnimation() {
        loadingIndicatorImageView.layer.removeAllAnimations()
    }
    
}
