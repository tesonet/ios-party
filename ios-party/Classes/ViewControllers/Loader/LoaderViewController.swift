//
//  LoaderViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

class LoaderViewController: UIViewController,
                            LoaderDataModelDelegate {

    // MARK: - Declarations
    var dataModel: LoaderDataModelInterface!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel = LoaderDataModel(delegate: self)
    }
}
