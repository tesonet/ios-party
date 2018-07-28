//
//  SortSelectionView.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class SortSelectionView: UIView {

    static let defaultHeight: CGFloat = 60
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ico-sort-light"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let title = NSLocalizedString("SORT", comment: "")
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        addSubview(sortButton)
        backgroundColor = Colors.sortViewBackgroundColor.withAlphaComponent(0.9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        guard let superview = self.superview else {
            fatalError("view should have a superview")
        }
        
        let constraints = [
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            heightAnchor.constraint(equalToConstant: SortSelectionView.defaultHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
        addButtonConstraints()
        addBlurViewConstraints()
    }
    
    private func addBlurViewConstraints() {
        let constraints = [
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addButtonConstraints() {
        let constraints = [sortButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                           sortButton.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
}
