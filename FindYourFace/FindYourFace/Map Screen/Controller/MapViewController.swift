//
//  MapViewController.swift
//  FindYourFace
//
//  Created by Roman on 8/27/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var presenter = MapControllerPresenter(with: self)
    
    let mapView = MKMapView()
    var targets = [ARItem]()
    let locationManager = CLLocationManager()
    let regionRadius: Double = 250
    var userLocation: CLLocation?
    var selectedAnnotation: MKAnnotation?
    
    let button = UIButton()
    let button2 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        mapView.delegate = self
        locationManager.delegate = self
        setupMapView()
        configureLocationServices()
        startUpdatingLocationManager()
        setupButton()
        setupSecondButton()
        presenter.view?.centerOnUserLocation()
    }
    
    @objc func moveToCustomVC() {
        presenter.view?.moveToObjectFinder()
    }
    
    @objc func moveToCustomVC2() {
        try? Auth.auth().signOut()
        if Auth.auth().currentUser?.uid == nil {
            let rootVC = ViewController()
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.modalPresentationStyle = .fullScreen
            self.present(rootNC, animated: true, completion: nil)
        }
    }
    
    func startUpdatingLocationManager() {
        presenter.view?.startUpdatingLocManager()
    }
    
    func configureLocationServices() {
        presenter.view?.confLocationServer()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenter.view?.centerOnUserLocation()
    }
    
    
    func setupLocations() {
        presenter.view?.setupMapLocations()
    }
    
    
    
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        return (presenter.view?.generateRandomCoord(min: min, max: max))!
    }
    
    
}

//MARK: - UI Configuration
extension MapViewController {
    func setupMapView() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
    func setupButton() {
        button.setImage(UIImage(named: "photo.png"), for: .normal)
        mapView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -50).isActive = true
        button.addTarget(self, action: #selector(moveToCustomVC2), for: .touchUpInside)
    }
    
    func setupSecondButton() {
        button2.setImage(UIImage(named: "camera.png"), for: .normal)
               mapView.addSubview(button2)
               button2.translatesAutoresizingMaskIntoConstraints = false
               button2.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
               button2.widthAnchor.constraint(equalToConstant: 50).isActive = true
               button2.heightAnchor.constraint(equalToConstant: 50).isActive = true
               button2.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20).isActive = true
               button2.addTarget(self, action: #selector(moveToCustomVC), for: .touchUpInside)
    }
}

//MARK: - Presenter Protocol Declaration
extension MapViewController: MapControllerPresenterView {
    
    func startUpdatingLocManager() {
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func generateRandomCoord(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {
        let currentLong = userLocation!.coordinate.longitude
        let currentLat = userLocation!.coordinate.latitude
        
        
        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)
        
        //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
    }
    
    
    func moveToObjectFinder() {
        let vc = LiveTimeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func centerOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func confLocationServer() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func setupMapLocations() {
        var num = self.mapView.annotations.count
        //First we declare While to repeat adding Annotation
        while num != 4 {
            num += 1
            
            let number = Int.random(in: 0...100)
            
            print(number)
            if (number <= 50) {
                let coordinate2 = generateRandomCoordinates(min: 10, max: 50)
                let item2 = ARItem(itemDescription: "wolf", location: CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude), itemNode: nil)
                let annotation2 = MapAnnotation(location: item2.location.coordinate, item: item2)
                self.mapView.addAnnotation(annotation2)
            } else if (number <= 80) {
                let coordinate3 = generateRandomCoordinates(min: 10, max: 50)
                let item3 = ARItem(itemDescription: "dragon", location: CLLocation(latitude: coordinate3.latitude, longitude: coordinate3.longitude), itemNode: nil)
                let annotation3 = MapAnnotation(location: item3.location.coordinate, item: item3)
                self.mapView.addAnnotation(annotation3)
            } else {
                let coordinate = generateRandomCoordinates(min: 10, max: 50)
                let item = ARItem(itemDescription: "Hotdog", location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), itemNode: nil)
                let annotation = MapAnnotation(location: item.location.coordinate, item: item)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

extension Array {
    /// Picks `n` random elements (partial Fisher-Yates shuffle approach)
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.location
        if (self.userLocation?.coordinate.latitude) != nil {
            setupLocations()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //1
        
        
        let coordinate = view.annotation!.coordinate
        //2
        
        if let userCoordinate = userLocation {
            //3
            
            if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 100 {
                //4
                
                
                let viewController = CameraViewController()
                viewController.modalPresentationStyle = .fullScreen
                viewController.userLocation = mapView.userLocation.location!
                viewController.delegate = self
                // more code later
                //5
                
                if let mapAnnotation = view.annotation as? MapAnnotation {
                    //1
                    viewController.target = mapAnnotation.item
                    viewController.userLocation = mapView.userLocation.location!
                    
                    //2
                    selectedAnnotation = view.annotation
                    self.present(viewController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
}

//MARK: - ARControllerDelegate
extension MapViewController: ARControllerDelegate {
    func viewController(controller: CameraViewController, tappedTarget: ARItem) {
        //1
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            
            //        let index = self.targets.index(where: {$0.itemDescription == tappedTarget.itemDescription})
            //       self.targets.remove(at: index!)
            
            if self.selectedAnnotation != nil {
                //3
                UserDefaults.standard.set(true, forKey: (self.selectedAnnotation!.title)!!)
                self.mapView.removeAnnotation(self.selectedAnnotation!)
                
            }
        }
        //
    }
}
