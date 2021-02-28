//
//  ServerListLogoView.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

class ServerListLogoView: UIImageView {
    override public var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        .init(top: 0, left: -8, bottom: 0, right: 0)
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        image = UIImage(named: "logo-dark")
        contentMode = .left
    }
}
