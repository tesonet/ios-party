import Foundation
import UIKit

class XibLoader {
	class func loadViewFromXib(name: String, of type: AnyClass, owner: Any?) -> UIView? {
		if let viewFromXib = Bundle.main.loadNibNamed(name, owner: owner, options: nil) {
			for view in viewFromXib {
				let view = view as! UIView
				if view.isKind(of: type) {
					return view
				}
			}
		}
		
		return nil
	}
	
	class func loadViewFromXib(name: String, type: AnyClass) -> UIView? {
		return XibLoader.loadViewFromXib(name: name, of: type, owner: nil)
	}
	
	class func loadViewFromXib(of type: AnyClass) -> UIView? {
		let name = NSStringFromClass(type).components(separatedBy: ".").last!
		return XibLoader.loadViewFromXib(name: name, of: type, owner: nil)
	}
}
