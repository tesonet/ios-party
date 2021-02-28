//
//  ServerListFetchViewController.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

final class ServerListFetchViewController: UIViewController, ServerListFetchView {

    enum Constants {
        static var loadingLabelColor: UIColor {
            .white
        }
        
        static var loadingLabelFont: UIFont {
            UIFont.systemFont(ofSize: 16)
        }
        
        static var loadingStatusText: String {
            "Fetching the list..."
        }
        
        static var retryButtonColor: UIColor {
            UIColor(named: "mainGray")!
        }
        
        static var retryButtonBgColor: UIColor {
            .white
        }
    }
    
    var onUnauthorized: (() -> Void)?
    var onSuccess: (() -> Void)?
    
    let viewModel: ServerListFetchViewModelProtocol
    
    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bg"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let loadingView: ServerListFetchLoadingView = {
        let view = ServerListFetchLoadingView()
        view.isHidden = true
        return view
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = Constants.retryButtonBgColor
        button.setTitleColor(Constants.retryButtonColor, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didSelectRetry), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.loadingStatusText
        label.font = Constants.loadingLabelFont
        label.textColor = Constants.loadingLabelColor
        label.isHidden = true
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    init(viewModel: ServerListFetchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load()
    }
    
    func setupViews() {
        view.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelTopGuide = UILayoutGuide()
        view.addLayoutGuide(labelTopGuide)
        
        let labelBottomGuide = UILayoutGuide()
        view.addLayoutGuide(labelBottomGuide)
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 80),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelTopGuide.topAnchor.constraint(equalTo: loadingView.bottomAnchor),
            labelTopGuide.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            labelBottomGuide.topAnchor.constraint(equalTo: statusLabel.bottomAnchor),
            labelBottomGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelTopGuide.heightAnchor.constraint(equalTo: labelBottomGuide.heightAnchor)
        ])
    }
    
    @objc func didSelectRetry() {
        viewModel.load()
    }
    
    func displayError(error: String) {
        loadingView.isHidden = true
        loadingView.stopAnimation()
        statusLabel.text = error
        statusLabel.isHidden = false
        
        retryButton.isHidden = false
    }
    
    func startLoadingAnimation() {
        loadingView.isHidden = false
        loadingView.startAnimation()
        statusLabel.text = Constants.loadingStatusText
        statusLabel.isHidden = false
        
        retryButton.isHidden = true
    }
}

extension ServerListFetchViewController: ServerListFetchViewModelDelegate {
    func didStartLoading() {
        startLoadingAnimation()
    }
    
    func didReceiveUnauthorized() {
        onUnauthorized?()
    }
    
    func didReceiveError(error: String) {
        displayError(error: error)
    }
    
    func didSaveItemsSuccessfully() {
        onSuccess?()
    }
}
