//
//  LoadingView.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    static private var shareInstanceView: LoadingView?
    
    let minimumAnimationDuration: TimeInterval = 1.0
    var startedAnimating: Date = Date()
    
    class func sharedInstance() -> LoadingView{
        if (LoadingView.shareInstanceView == nil){
            LoadingView.shareInstanceView = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)?[0] as? LoadingView
        }
        return shareInstanceView!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont.applicationFont(.light, size: 12)
        label.textColor = UIColor.white
    }
    
    private func animate() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = Float.pi * 2
        anim.duration = 1.2
        anim.repeatCount = Float.infinity
        loadingImage.layer.add(anim, forKey: "spin")
    }
    private func stopAnimating() {
        loadingImage.layer.removeAllAnimations()
    }
    func start(text: String = "") {
        let window = UIApplication.shared.windows[0]
        
        label.text = text
        self.startedAnimating = Date()
        
        if !window.subviews.contains(self) {
            window.addSubview(self)
            self.frame = window.bounds
            self.alpha = 0
            
            animate()
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.alpha = 1
            })
        }
    }
    func stop() {
        
        let leftDuration = startedAnimating.timeIntervalSinceNow + minimumAnimationDuration
        
        UIView.animate(withDuration: 0.15, delay: max(0, leftDuration), options: [], animations: {
            self.alpha = 0
        }) { (completion) in
            self.removeFromSuperview()
            self.stopAnimating()
        }
    }

}
