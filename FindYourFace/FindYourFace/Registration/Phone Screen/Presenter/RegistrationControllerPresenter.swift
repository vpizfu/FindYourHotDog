//
//  RegistrationControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol RegistrationControllerPresenterView: class {
    func hideKeyboard()
    func authViaPhone()
    func showKeyboard(notification: NSNotification)
    func setupKeyboardNotifications()
}

class RegistrationControllerPresenter {
    weak var view: RegistrationControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: RegistrationControllerPresenterView) {
        self.view = view
    }
    
}
