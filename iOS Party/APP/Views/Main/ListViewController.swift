//
//  ListViewController.swift
//  iOS Party
//
//  Created by Justas Liola on 14/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit
import RxSwift

final class ListViewController: UIViewController {
    
    //A side note, it would be great if images were in .pdf format and would be proper size
    //Constrain, font size also would be great, a little bit hard to guesstimate them from image. 
    
    @IBOutlet private var loadingView:   UIView!
    @IBOutlet private var loadingCircle: UIImageView!
    @IBOutlet private var logOutButton:  UIButton!
    @IBOutlet private var tableView:     UITableView!
    @IBOutlet private var shadowView:    UIView!
    
    private let serverListVM = ServerListVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        serverListVM.fetchServers()
        setupUI()
        setupTableView()
        setupActions()
    }
    
    //MARK: Setup
    
    private func setupUI() {
        setupLoadingView()
        addGradientShadow()
    }
    
    private func setupTableView() {
        serverListVM.servers
            .bind(to: tableView.rx.items(cellIdentifier: ServerTableViewCell.reuseIdentifier, cellType: ServerTableViewCell.self)) { (_, serverData, cell) in
                cell.setup(with: serverData)
            }
            .addDisposableTo(rx_disposeBag)
    }
    
    private func setupActions() {
        logOutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                API.Headers.clear()
                UIApplication.shared.keyWindow?.rootViewController = self?.storyboard?.instantiateViewController(withIdentifier: "\(ListViewController.self)")
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    //MARK: Loading animations
    
    private func setupLoadingView() {
        serverListVM.loading
            .map{ !$0 }
            .bind(to: loadingView.rx.isHidden)
            .addDisposableTo(rx_disposeBag)
        
        serverListVM.loading
            .subscribeNext(self, ListViewController.animateCircle)
    }
    
    private func animateCircle(animate: Bool) {
        if animate {
            rotateView()
        } else {
            loadingCircle.layer.removeAllAnimations()
        }
    }
    
    private func rotateView() {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: { _ in
            self.loadingCircle.transform = self.loadingCircle.transform.rotated(by: .pi)
        }) { _ in
            self.rotateView()
        }
    }
    
    //MARK: Gradient shadow
    private func addGradientShadow() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors =     [UIColor.appGray.withAlphaComponent(1).cgColor,
                                    UIColor.white  .withAlphaComponent(0).cgColor]
        gradientLayer.bounds =      shadowView.bounds
        gradientLayer.anchorPoint = CGPoint()
        shadowView.layer.addSublayer(gradientLayer)
    }
}
