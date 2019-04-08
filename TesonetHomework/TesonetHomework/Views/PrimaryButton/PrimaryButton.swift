// Created by Paulius Cesekas on 02/04/2019.

import UIKit

class PrimaryButton: UIButton {
    // MARK: - Variables
    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.Button.background
            } else {
                backgroundColor = UIColor.Button.background.withAlphaComponent(Constants.disabledAlpha)
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
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.Button.background
        setTitleColor(
            UIColor.Button.foreground,
            for: .normal)
        setTitleColor(
            UIColor.Button.foreground.withAlphaComponent(Constants.disabledAlpha),
            for: .disabled)
        titleLabel?.font = UIFont.buttonTitle
        layer.cornerRadius = Constants.cornerRadius
    }
}
