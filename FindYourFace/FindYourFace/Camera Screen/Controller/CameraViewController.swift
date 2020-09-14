//
//  CameraViewController.swift
//  FindYourFace
//
//  Created by Roman on 8/27/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation
import CoreLocation
import SceneKit.ModelIO

class CameraViewController: UIViewController {
    
    lazy var presenter = CameraViewControllerPresenter(with: self)
    
    let sceneView = SCNView()
    var cameraSession: AVCaptureSession?
    var cameraLayer: AVCaptureVideoPreviewLayer?
    var target: ARItem!
    
    var locationManager = CLLocationManager()
    var heading: Double = 0
    var userLocation = CLLocation()
    //2
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    var delegate: ARControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.backgroundColor = .clear
        setupSceneView()
        
        loadCamera()
        self.cameraSession?.startRunning()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingHeading()
    
        sceneView.scene = scene
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        setupTarget()
    }
    
    
    func loadCamera() {
        presenter.view?.loadUserCamera()
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return (presenter.view?.radToDegrees(radians))!
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return (presenter.view?.degreesToRad(degrees))!
    }
    
    func getHeadingForDirectionFromCoordinate(from: CLLocation, to: CLLocation) -> Double {
        //1
        return (presenter.view?.getCurrentHeading(from: from, to: to))!
    }
    
    func repositionTarget() {
        presenter.view?.repostionSCTarget()
    }
    
    func setupTarget() {
        presenter.view?.setupSCTarget()
    }
    
    func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?) {
           //1
           var error: NSError?
           var captureSession: AVCaptureSession?
           
           //2
           let backVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
           
           //3
           if backVideoDevice != nil {
               var videoInput: AVCaptureDeviceInput!
               do {
                   videoInput = try AVCaptureDeviceInput(device: backVideoDevice!)
               } catch let error1 as NSError {
                   error = error1
                   videoInput = nil
               }
               
               //4
               if error == nil {
                   captureSession = AVCaptureSession()
                   
                   //5
                   if captureSession!.canAddInput(videoInput) {
                       captureSession!.addInput(videoInput)
                   } else {
                       error = NSError(domain: "", code: 0, userInfo: ["description": "Error adding video input."])
                   }
               } else {
                   error = NSError(domain: "", code: 1, userInfo: ["description": "Error creating capture device input."])
               }
           } else {
               error = NSError(domain: "", code: 2, userInfo: ["description": "Back video device not found."])
           }
           
           //6
           return (session: captureSession, error: error)
       }
}

//MARK:- UI Configuration
extension CameraViewController {
    func setupSceneView() {
        self.view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: - TouchesEnded Implementation
extension CameraViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        
        //2
        let hitResult = sceneView.hitTest(location, options: nil)
        //3
        let fireBall = SCNParticleSystem(named: "Fireball.scnp", inDirectory: nil)
        //4
        let emitterNode = SCNNode()
        emitterNode.position = SCNVector3(x: 0, y: -5, z: 10)
        emitterNode.addParticleSystem(fireBall!)
        scene.rootNode.addChildNode(emitterNode)
        
        //5
        if hitResult.first != nil {
            target.itemNode?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5), SCNAction.removeFromParentNode(), SCNAction.hide()]))
            //1
            let sequence = SCNAction.sequence(
                [SCNAction.move(to: target.itemNode!.position, duration: 0.5),
                 //2
                    SCNAction.wait(duration: 1.5),
                    //3
                    SCNAction.run({_ in
                        self.delegate?.viewController(controller: self, tappedTarget: self.target)
                    })])
            emitterNode.runAction(sequence)
        } else {
            //7
            emitterNode.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -30), duration: 0.5))
        }
    }
}

//MARK: - Presenter Protocol Declaration
extension CameraViewController: CameraViewControllerPresenterView {

    
    func loadUserCamera() {
        //1
        let captureSessionResult = createCaptureSession()
        
        //2
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else {
            print("Error creating capture session.")
            return
        }
        
        //3
        self.cameraSession = session
        
        //4
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession!)
        if cameraLayer != nil {
            cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraLayer.frame = self.view.bounds
            //5
            self.view.layer.insertSublayer(cameraLayer, at: 0)
            self.cameraLayer = cameraLayer
        }
    }
    
    func radToDegrees(_ radians: Double) -> Double {
        return (radians) * (180.0 / M_PI)
    }
    
    func degreesToRad(_ degrees: Double) -> Double {
        return (degrees) * (M_PI / 180.0)
    }
    
    func getCurrentHeading(from: CLLocation, to: CLLocation) -> Double {
        let fLat = degreesToRadians(from.coordinate.latitude)
        let fLng = degreesToRadians(from.coordinate.longitude)
        let tLat = degreesToRadians(to.coordinate.latitude)
        let tLng = degreesToRadians(to.coordinate.longitude)
        
        //2
        let degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
        //3
        if degree >= 0 {
            return degree
        } else {
            return degree + 360
        }
    }
    
    func setupSCTarget() {
        //let scene = SCNScene(named: "art.scnassets/fox.dae")
        var scene = SCNScene()
        
        var enemy = SCNNode()
        if target.itemDescription == "dragon" {
            scene = SCNScene(named: "art.scnassets/dragon.dae")!
            enemy = scene.rootNode.childNode(withName: "dragon", recursively: true)!
        } else if target.itemDescription == "wolf" {
            scene = SCNScene(named: "art.scnassets/wolf.dae")!
            enemy = scene.rootNode.childNode(withName: "wolf", recursively: true)!
        } else {
            guard let url = Bundle.main.url(forResource: "hotdog", withExtension: "obj") else { fatalError() }
            let mdlAsset = MDLAsset(url: url)
            scene = SCNScene(mdlAsset: mdlAsset)
            enemy = scene.rootNode.childNode(withName: "Figure_bottombread", recursively: true)!
        }
        //3
        if target.itemDescription == "dragon" {
            enemy.position = SCNVector3(x: 0, y: -15, z: 0)
        } else {
            enemy.position = SCNVector3(x: 0, y: 0, z: 0)
        }
        
        //4
        let node = SCNNode()
        node.addChildNode(enemy)
        node.name = "enemy"
        self.target.itemNode = node
    }
    
    func repostionSCTarget() {
        //1
        let heading = getHeadingForDirectionFromCoordinate(from: userLocation, to: target.location)
        
        //2
        let delta = heading - self.heading
        
        
        
        //3
        let distance = userLocation.distance(from: target.location)
        //print("distane is \(distance)")
        //4
        if let node = target.itemNode {
            
            //5
            if node.parent == nil {
                node.position = SCNVector3(x: Float(delta), y: 0, z: Float(-distance))
                scene.rootNode.addChildNode(node)
            } else {
                //6
                node.removeAllActions()
                node.runAction(SCNAction.move(to: SCNVector3(x: Float(delta), y: 0, z: Float(-distance)), duration: 0.2))
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //1
        self.heading = fmod(newHeading.trueHeading, 360.0)
        repositionTarget()
    }
}

//MARK: - Protocol ARControllerDelegate
protocol ARControllerDelegate {
    func viewController(controller: CameraViewController, tappedTarget: ARItem)
}
