import UIKit

class HeaderView: UITableViewHeaderFooterView {
	static let reuseIdentifer: String = "HeaderViewReuseIdentifer"
	@IBOutlet weak var labelServer: UILabel!
	@IBOutlet weak var labelDistance: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.backgroundView = UIView()
		self.backgroundView?.backgroundColor = UIColor(white: 1.0, alpha: 0.8)

		labelServer.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(15)
			make.height.equalTo(30)
			make.width.equalTo(150)
			make.centerY.equalToSuperview()
		}
		
		labelDistance.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-15)
			make.height.equalTo(30)
			make.width.equalTo(150)
			make.centerY.equalToSuperview()
		}
	}
}
