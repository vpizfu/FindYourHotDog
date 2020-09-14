//
//  FilterViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol FilterViewControllerPresenterView: class {
    func applyCustomFilter()
    func saveOurImage()
}

class FilterViewControllerPresenter {
    weak var view: FilterViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: FilterViewControllerPresenterView) {
        self.view = view
    }
}
