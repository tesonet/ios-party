//
//  MainLoadingViewModel.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-20.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class MainLoadingViewModel: ViewModel {
    
    var view: UIView?
    
    func buildView() -> UIView {
        return MainLoadingView.instantiateFromXib()
    }
    
    func pinConstraints(view: UIView, superView: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoPinEdgesToSuperviewEdges()
    }
    
    func handleData(view: UIView) {}
    
}
