//
//  LoaderDataModel.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

protocol LoaderDataModelDelegate: AnyObject {
    
}

protocol LoaderDataModelInterface {
    
}

class LoaderDataModel: LoaderDataModelInterface {
    
    // MARK: - Declarations
    weak var delegate: LoaderDataModelDelegate?
    
    // MARK: - Methods
    init(delegate: LoaderDataModelDelegate) {
        self.delegate = delegate
    }
}
