//
//  WelcomeViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation
import CoreImage

protocol WelcomeViewControllerPresenterView: class {
    func hotdogClassifier(image: CIImage)
    func showPicker()
}

class WelcomeViewControllerPresenter {
    weak var view: WelcomeViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: WelcomeViewControllerPresenterView) {
        self.view = view
    }
}
   
