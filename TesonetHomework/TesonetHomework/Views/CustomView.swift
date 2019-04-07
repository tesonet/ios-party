// Created by Paulius Cesekas on 07/04/2019.

import UIKit

class CustomView: UIView {
    @IBOutlet private weak var contentView: UIView!
    
    func loadViewFromNib() {
        Bundle.main.loadNibNamed(
            Utility.classNameAsString(self),
            owner: self,
            options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        awakeFromNib()
    }
}
