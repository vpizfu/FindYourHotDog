//
//  CameraViewControllerPresenter.swift
//  FindYourFace
//
//  Created by Roman on 9/7/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation

protocol CameraViewControllerPresenterView: class {
    func setupSCTarget()
    func repostionSCTarget()
    func getCurrentHeading(from: CLLocation, to: CLLocation) -> Double
    func degreesToRad(_ degrees: Double) -> Double
    func radToDegrees(_ radians: Double) -> Double
    func loadUserCamera()
}

class CameraViewControllerPresenter {
    weak var view: CameraViewControllerPresenterView?
// Pass something that conforms to PresenterView
    init(with view: CameraViewControllerPresenterView) {
        self.view = view
    }
    
}
