//
//  LoginButton.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class LoginButton: UIButton {
    
    enum Constants {
        static var bgColor: UIColor {
            UIColor(named: "green")!
        }
        
        static var tintColor: UIColor {
            .white
        }

        static var height: CGFloat {
            50
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: super.intrinsicContentSize.width,
            height: Constants.height
        )
    }

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setTitle("Log In", for: .normal)
        setTitleColor(Constants.tintColor, for: .normal)
        backgroundColor = Constants.bgColor
        clipsToBounds = true
        layer.cornerRadius = 4
        
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func startAnimation() {
        isEnabled = false
        titleLabel?.alpha = 0
        activityIndicator.startAnimating()
    }
    
    public func stopAnimation() {
        isEnabled = true
        activityIndicator.stopAnimating()
        titleLabel?.alpha = 1
    }
}
