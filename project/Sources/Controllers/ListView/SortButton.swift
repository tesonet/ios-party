import UIKit
import SnapKit

class SortButton: UIButton {
	
	@IBOutlet var _hStackView: UIStackView!

	override func awakeFromNib() {
		super.awakeFromNib()
		
		_hStackView.snp.makeConstraints { (make) in
			make.height.equalTo(20)
			make.width.equalTo(50)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview()
		}
	}
}
