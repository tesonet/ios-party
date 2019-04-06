//
//  LoadingButton.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingButton: UIButton {
    
    private var _isLoading: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    // MARK: Loading
    var isLoading: Bool {
        get { return _isLoading }
        set {
            guard newValue != isLoading || newValue  else { return }
            isUserInteractionEnabled = !newValue
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            _isLoading = newValue
            titleToCache(newValue)
        }
    }
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = self.titleColor(for: .normal)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        return activityIndicator
    }()
    
    // MARK: Hiding title
    
    private var cachedImage: UIImage?
    private var cachedTitle: String?
    private var cachedAttrTitle: NSAttributedString?
    
    private func titleToCache(_ toCache: Bool = true) {
        let imageToCache =      toCache ? image(for: .normal) : nil
        let imageToButton =     toCache ? nil : cachedImage
        let titleToCache =      toCache ? title(for: .normal) : nil
        let titleToButton =     toCache ? nil : cachedTitle
        let attrTitleToCache =  toCache ? attributedTitle(for: .normal) : nil
        let attrTitleToButton = toCache ? nil : cachedAttrTitle
        
        if let imageToCache = imageToCache { cachedImage = imageToCache }
        if let titleToCache = titleToCache { cachedTitle = titleToCache }
        if let attrTitleToCache = attrTitleToCache { cachedAttrTitle = attrTitleToCache }
        
        setImage(imageToButton, for: .normal)
        setTitle(titleToButton, for: .normal)
        setAttributedTitle(attrTitleToButton, for: .normal)
    }
}

extension Reactive where Base: LoadingButton {
    /// Bindable sink for `isLoading` property.
    var isLoading: Binder<Bool> {
        return Binder(self.base) { button, isLoading in
            button.isLoading = isLoading
        }
    }
}
