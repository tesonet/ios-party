// Created by Paulius Cesekas on 02/04/2019.

import UIKit

class PrimaryTextField: UITextField {
    // MARK: - Variables
    @IBInspectable
    var leftViewImage: UIImage? = nil {
        didSet {
            if let image = leftViewImage {
                setupLeftView(image)
            } else {
                leftView = nil
                leftViewMode = .never
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
        backgroundColor = UIColor.Input.background
        font = .inputText
        textColor = UIColor.Input.foreground
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func setupLeftView(_ image: UIImage) {
        let leftView = UIImageView(image: image)
        leftView.contentMode = .center
        leftView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.size.height * Constants.textFieldLeftViewAspectRatio,
            height: bounds.size.height)
        self.leftView = leftView
        self.leftView?.tintColor = UIColor.Input.foreground
        leftViewMode = .always
    }
}
