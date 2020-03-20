//
//  LoginButtonModel.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol LoginButtonModelDelegate: class {
    func loginAction()
}

class LoginButtonModel: ViewModel {
    
    var view: UIView?
    private let padding: CGFloat = 40
    private let height: CGFloat = 60
    private let horizontalOffset: CGFloat = 75
    private let buttonText = "Log In"
    
    var loading = false {
        didSet {
            handleLoading()
        }
    }
    
    weak var delegate: LoginButtonModelDelegate?
    
    func buildView() -> UIView {
        return LoginButtonView.instantiateFromXib()
    }
    
    func pinConstraints(view: UIView, superView: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoPinEdge(.leading, to: .leading, of: superView, withOffset: padding)
        view.autoPinEdge(.trailing, to: .trailing, of: superView, withOffset: -padding)
        view.autoAlignAxis(.horizontal, toSameAxisOf: superView, withOffset: horizontalOffset)
        view.autoSetDimension(.height, toSize: height)
    }
    
    func handleData(view: UIView) {
        guard let buttonView = view as? LoginButtonView else { return }
        buttonView.button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        handleLoading()
    }

    @objc private func loginAction() {
        delegate?.loginAction()
    }
    
    private func handleLoading() {
        guard let buttonView = view as? LoginButtonView else { return }
        
        buttonView.activityIndicator.isHidden = !loading
        buttonView.button.setTitle(loading ? "" : buttonText, for: .normal)
        buttonView.button.isEnabled = !loading
        
        if loading {
            buttonView.activityIndicator.startAnimating()
        }
    }
    
}
