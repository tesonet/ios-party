//
//  LoadingIndicator.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import UIKit
import PureLayout

protocol LoadingIndicator: AnyObject {
    
    var viewToDisplayIndicator: UIView { get }
    var loadingIndicatorView: UIActivityIndicatorView? { get set }
    
    func showLoading()
    func hideLoading()
}

extension LoadingIndicator {
    
    // MARK: - Methods
    func showLoading() {
        
        if loadingIndicatorView == nil {
            loadingIndicatorView = addLoadingIndicator(on: viewToDisplayIndicator)
        }
        
        loadingIndicatorView?.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicatorView?.stopAnimating()
    }
    
    // MARK: - Helpers
    private func addLoadingIndicator(on view: UIView) -> UIActivityIndicatorView {
        
        let loadingIndicator = self.loadingIndicator()
        view.addSubview(loadingIndicator)
        loadingIndicator.autoPinEdgesToSuperviewEdges()
        
        return loadingIndicator
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.backgroundColor = .clear
        loadingIndicator.configureForAutoLayout()
        
        return loadingIndicator
    }
}
