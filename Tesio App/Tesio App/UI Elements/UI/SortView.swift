//
//  SortView.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/27/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit

class SortView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageAndLabelStackView: UIStackView!
    
    // For using custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // For using custom view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = TesioHelper.Constant.Color.mainDarkBlue
    }
  
}
