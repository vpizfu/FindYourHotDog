//
//  LiveTimeViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol LiveTimeViewControllerPresenterView: class {
    func dismissController()
    func setupCamera()
}

class LiveTimeViewControllerPresenter {
    weak var view: LiveTimeViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: LiveTimeViewControllerPresenterView) {
        self.view = view
    }
}
