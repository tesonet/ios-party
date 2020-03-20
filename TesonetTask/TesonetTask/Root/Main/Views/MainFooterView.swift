//
//  MainFooterView.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-20.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol MainFooterViewDelegate: class {
    func sortAction()
}

class MainFooterView: UIView {
    
    weak var delegate: MainFooterViewDelegate?
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
    }
    
    @objc private func sortAction() {
        delegate?.sortAction()
    }
    
}
