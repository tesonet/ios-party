// Created by Paulius Cesekas on 02/04/2019.

import UIKit

class PrimaryButton: UIButton {
    // MARK: - Variables
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.primary
                imageView?.tintColor = UIColor.secondary
            } else {
                backgroundColor = UIColor.primary.withAlphaComponent(Constants.disabledAlpha)
                imageView?.tintColor = UIColor.secondary.withAlphaComponent(Constants.disabledAlpha)
            }
        }
    }
    
    // MARK: - Methods -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.primary
        setTitleColor(
            UIColor.secondary,
            for: .normal)
        setTitleColor(
            UIColor.secondary.withAlphaComponent(Constants.disabledAlpha),
            for: .disabled)
        imageView?.tintColor = UIColor.secondary
        titleLabel?.font = UIFont.button
        updateCornerRadius()
    }
    
    // MARK: - Helpers
    private func updateCornerRadius() {
        let cornerRadius = bounds.size.height / 2
        layer.cornerRadius = cornerRadius
    }
}
