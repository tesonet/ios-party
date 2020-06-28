//
//  LoadingViewController.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/26/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, UINavigationControllerDelegate {
    
    private var username:String!
    private var token:String!
    private let simpleOver = AnimationManager()
    private let spinner = SpinnerView()
    
    convenience init (token:String)
    {
        self.init()
        self.token = token
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        setupUI()
        APIManager().getServers(token: self.token) { (success, serversList) in
            if success
            {
                let serversViewController = ServersViewController.init(servers: serversList!)
                self.navigationController?.pushViewController(serversViewController, animated: true)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        spinner.stopRotating()
    }
    
    fileprivate func setupUI()
    {
        assignbackground()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 150).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 150).isActive = true
        spinner.rotate()
        
        let label:UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fetching the list..."
        view.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -130).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    fileprivate func assignbackground()
    {
        let background = UIImage(named: "Background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.center
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}

extension LoadingViewController: UIViewControllerTransitioningDelegate
{
        func navigationController(
            _ navigationController: UINavigationController,
            animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            simpleOver.popStyle = (operation == .none)
            return simpleOver
        }
}


extension SpinnerView
{

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: SpinnerView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: SpinnerView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: SpinnerView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: SpinnerView.kRotationAnimationKey)
        }
    }
}
