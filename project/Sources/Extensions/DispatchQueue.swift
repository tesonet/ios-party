import Foundation

extension DispatchQueue {
	
	func asyncAfter(_ seconds: Double, work: @escaping @convention(block) () -> Void) {
		asyncAfter(deadline: .now() + seconds, execute: work)
	}
}
