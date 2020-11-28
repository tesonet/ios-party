//
//  ImageTextFieldView.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class ImageTextFieldView: UIView {
    
    // MARK: - Declarations
    @IBOutlet private(set) weak var contentView: UIView!
    
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var textField: UITextField!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadContentView()
    }
    
    private func loadContentView() {
        let bundle = Bundle(for: ImageTextFieldView.self)
        
        bundle.loadNibNamed("ImageTextFieldView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Public
    func setupUI(image: UIImage?, placeholder: String, isPasswordEntry: Bool = false) {
        reset()
        
        set(image: image)
        set(placeholder: placeholder)
        
        textField.isSecureTextEntry = isPasswordEntry
    }
    
    private func reset() {
        set(image: nil)
        set(text: "")
        set(placeholder: "")
    }
    
    private func set(image: UIImage?) {
        imageView.image = image
    }
    
    private func set(text: String) {
        textField.text = text
    }
    
    private func set(placeholder: String) {
        textField.placeholder = placeholder
    }
}
