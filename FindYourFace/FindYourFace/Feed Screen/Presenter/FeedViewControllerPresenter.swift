//
//  FeedViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

protocol FeedViewControllerPresenterView: class {
    func fetchDataForCollectionView()
}

class FeedViewControllerPresenter {
    weak var view: FeedViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: FeedViewControllerPresenterView) {
        self.view = view
    }
}
