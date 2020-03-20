//
//  ViewModel.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit
import PureLayout

protocol ViewModel {
    
    func buildView() -> UIView
    func pinConstraints(view: UIView, superView: UIView)
    func handleData(view: UIView)
    var view: UIView? { get set }
    
}

protocol ViewModelAdder {
    func add(model: ViewModel)
}

extension UIView: ViewModelAdder {
    
    func add(model: ViewModel) {
        let view = model.buildView()
        addSubview(view)
        model.pinConstraints(view: view, superView: self)
        model.handleData(view: view)
    }
    
}
