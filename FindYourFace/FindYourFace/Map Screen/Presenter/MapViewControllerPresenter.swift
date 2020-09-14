//
//  MapViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapControllerPresenterView: class {
    func moveToObjectFinder()
    func centerOnUserLocation()
    func confLocationServer()
    func setupMapLocations()
    func generateRandomCoord(min: UInt32, max: UInt32)-> CLLocationCoordinate2D
    func startUpdatingLocManager()
}

class MapControllerPresenter {
    weak var view: MapControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: MapControllerPresenterView) {
        self.view = view
    }
    
}
