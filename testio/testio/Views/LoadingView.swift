import UIKit

class LoadingView: UIView {
    @IBOutlet weak private var indicatorImageView: UIImageView!
    @IBOutlet weak private var messageLabel: UILabel!
    
    var message: String? { didSet { messageLabel.text = message } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMessageLabel()
    }
    
    // MARK: Setup
    
    func setupMessageLabel() {
        messageLabel.text = ""
    }
    
    // MARK: Animations
    
    func animate() {
        let kAnimationKey = "rotation"
        if indicatorImageView.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 1
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            indicatorImageView.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopAnimation() {
        let kAnimationKey = "rotation"
        
        if indicatorImageView.layer.animation(forKey: kAnimationKey) != nil {
            indicatorImageView.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
