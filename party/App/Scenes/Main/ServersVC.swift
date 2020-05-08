//
//  ServersVC.swift
//  party
//
//  Created by Paulius on 07/01/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback

final class ServersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
//        API.Servers.Get().request()
//            .subscribe(onSuccess: { (aaa) in
//                print(aaa)
//            })
//            .disposed(by: rx.disposeBag)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let logoutImg = UIImage(named: "ico-logout")?.withRenderingMode(.alwaysOriginal)
        let logoutButton = UIBarButtonItem(image: logoutImg, style: .plain, target: nil, action: nil)
        let logoImg = UIImage(named: "logo-dark")?.withRenderingMode(.alwaysOriginal)
        let logo = UIBarButtonItem(image: logoImg, style: .plain, target: nil, action: nil)
        navigationItem.setRightBarButton(logoutButton, animated: false)
        navigationItem.setLeftBarButton(logo, animated: false)
    }
}
