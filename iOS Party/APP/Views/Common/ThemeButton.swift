//
//  ThemeButton.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
final class ThemeButton: UIButton {
    
    @IBInspectable var themeColor: UIColor = UIColor.appGreen
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? themeColor.highlightedColor : themeColor
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        setTitleColor(.white, for: .normal)
        backgroundColor = themeColor
        layer.cornerRadius = 4
    }


    // MARK: Loading
    var loading: Bool {
        get { return activityIndicator.isAnimating }
        set {
            guard newValue != loading  || newValue && titleChanged() else { return }
            
            isUserInteractionEnabled = !newValue
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
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
    
    private func titleChanged() -> Bool {
        return cachedTitle != title(for: .normal) ||
            cachedAttrTitle != attributedTitle(for: .normal)
    }
    
    private func titleToCache(_ toCache: Bool = true) {
        let imageToCache =      toCache ? image(for: .normal) : nil
        let imageToButton =     toCache ? nil : cachedImage
        let titleToCache =      toCache ? title(for: .normal) : nil
        let titleToButton =     toCache ? nil : cachedTitle
        let attrTitleToCache =  toCache ? attributedTitle(for: .normal) : nil
        let attrTitleToButton = toCache ? nil : cachedAttrTitle
        
        cachedImage = imageToCache
        setImage(imageToButton, for: .normal)
        cachedTitle = titleToCache
        setTitle(titleToButton, for: .normal)
        cachedAttrTitle = attrTitleToCache
        setAttributedTitle(attrTitleToButton, for: .normal)
    }
    
    private func updateCache() {
        cachedImage = image(for: .normal)
        cachedTitle = title(for: .normal)
        cachedAttrTitle = attributedTitle(for: .normal)
    }
    
}

//MARK: RxSwift extensions

extension Reactive where Base: ThemeButton {
    /// Bindable sink for `isLoading` property.
    var isLoading: AnyObserver<Bool> {
        return UIBindingObserver(UIElement: self.base) { view, loading in
            view.loading = loading
            }.asObserver()
    }
}
