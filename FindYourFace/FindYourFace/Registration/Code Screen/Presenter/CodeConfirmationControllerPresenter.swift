//
//  CodeConfirmationControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation
import UIKit

protocol CodeConfirmationPresenterView: class {
    func authWithSms()
    func parseCode(textField: UITextField)
}

class CodeConfirmationPresenter {
    weak var view: CodeConfirmationPresenterView?
// Pass something that conforms to PresenterView
    init(with view: CodeConfirmationPresenterView) {
        self.view = view
    }
    
}
