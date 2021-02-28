//
//  LoginTextField.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class LoginTextField: UITextField {
    
    private enum Constants {
        static var placeholderColor: UIColor  {
            UIColor(named: "secondaryGray")!
        }
        
        static var textColor: UIColor {
            .black
        }
        
        static var bgColor: UIColor {
            .white
        }
        
        static var textPadding: UIEdgeInsets {
            .init(
                top: 10,
                left: 36,
                bottom: 10,
                right: 16
            )
        }
    }
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.tintColor = Constants.placeholderColor
        return view
    }()
    
    public var nextField: UITextField?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    public func add(icon: UIImage?) {
        iconImageView.image = icon
    }
    
    public func add(placeholder: String?) {
        guard let placeholder = placeholder else {
            attributedPlaceholder = nil
            return
        }
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: Constants.placeholderColor]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.textPadding.left + 8)
        ])
        
        textColor = Constants.textColor
        backgroundColor = Constants.bgColor
        borderStyle = .roundedRect
        tintColor = Constants.placeholderColor
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: Constants.textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: Constants.textPadding)
    }
}
