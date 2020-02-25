//
//  LoadingView.swift
//  Tesonet
//

import UIKit

class LoadingView: UIView {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingLabel: UILabel!

    func startLoading() {
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }

    func prepareView() {
        stopLoading()
        loadingLabel.text = "LoadingLabel".localized
        loadingLabel.textColor = UIColor.white
    }
}
