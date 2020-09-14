//
//  ProfileViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol ProfileViewControllerPresenterView: class {
    func showImagePicker()
    func saveDataToFirebase()
    func loadImageFromCoreData()
    func coreDataSetup()
}

class ProfileViewControllerPresenter {
    weak var view: ProfileViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: ProfileViewControllerPresenterView) {
        self.view = view
    }
}
