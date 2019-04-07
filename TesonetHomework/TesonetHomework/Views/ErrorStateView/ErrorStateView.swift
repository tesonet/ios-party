// Created by Paulius Cesekas on 07/04/2019.

import UIKit
import RxSwift

class ErrorStateView: CustomView {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Methods -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.status
        titleLabel.textColor = UIColor.body
        titleLabel.text = L10n.Common.Error.pleaseTryAgain
    }
}
