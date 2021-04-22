//
//  BaseButton.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

class BaseButton: UIButton {
    
    var didTap: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    @objc func buttonDidTap() {
        didTap?()
    }
}
