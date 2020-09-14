//
//  ViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol ViewControllerPresenterView: class {
    func presentVC()
}

class ViewControllerPresenter {
    weak var view: ViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: ViewControllerPresenterView) {
        self.view = view
    }
    
}
