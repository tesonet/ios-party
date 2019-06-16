import UIKit

final class ActivityIndicatorView: UIView {
    
    lazy private var backgroundImage: UIImageView = {
        let image = UIImage(named: "loading-screen")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var loaderImage: UIImageView = {
        let image = UIImage(named: "loader")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupBackground()
        setupLoader()
    }
    
    private func setupBackground() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupLoader() {
        addSubview(loaderImage)
        NSLayoutConstraint.activate([
            loaderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            loaderImage.widthAnchor.constraint(equalToConstant: 150),
            loaderImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = 1
        animation.isCumulative = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        loaderImage.layer.add(animation, forKey:"transform.rotation.z")
    }
}
