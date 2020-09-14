//
//  WelcomeViewController.swift
//  FindYourFace
//
//  Created by Roman on 9/3/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Firebase

class WelcomeViewController: UIViewController {
    
    lazy var presenter = WelcomeViewControllerPresenter(with: self)
    
    let welcomeLabel: UILabel = {
       let label = UILabel()
        label.text = "Welcome to \nHotDogNet"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let quickCreationLabel: UILabel = {
        let label = UILabel()
        label.text = "Fast upload"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    
    let quickCreationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload your HotDog \nphotos everywhere! \nJust click upload button and \nadd photo to the library!"
        label.numberOfLines = 4
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    
    let upvoteLabel: UILabel = {
        let label = UILabel()
         label.text = "Growth community"
               label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
               label.textAlignment = .left
        return label
    }()
    
    
    let upvoteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Upvote photos, which \nyou like. Share with friends \nand increase our society!"
        label.numberOfLines = 3
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    let newFeaturesLabel: UILabel = {
        let label = UILabel()
         label.text = "New features"
               label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
               label.textAlignment = .left
        return label
    }()
    
    let newFeaturesDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Try new features \nsuch as ARKit and CoreML."
        label.numberOfLines = 2
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()

    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload image", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 19)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return button
    }()
    
    let firstImageView = UIImageView(image: UIImage(named: "firstImage.jpg"))
    let secondImageView = UIImageView(image: UIImage(named: "secondImage.jpg"))
    let thirdImageView = UIImageView(image: UIImage(named: "thirdImage.jpg"))
    var classificationResults : [VNClassificationObservation] = []
    let imageFinder = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        imageFinder.delegate = self
        setupWelcomeLabel()
        setupSecondImageView()
        setupQuickCreationLabel()
        setupQuickCreationDescriptionLabel()
        setupUpvoteLabel()
        setupUpvoteDescriptionLabel()
        setupThirdImageView()
        setupNewFeaturesDescriptionLabel()
        setupNewFeaturesLabel()
        setupFirstImageView()
        setupCcontinueButton()
    }
    
    
    @objc func uploadImage() {
        presenter.view?.showPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
}

//MARK: - UI Configuration
extension WelcomeViewController {
    
    func setupWelcomeLabel() {
        self.view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
    }
    
    func setupSecondImageView() {
        secondImageView.layer.cornerRadius = 10
        secondImageView.layer.masksToBounds = true
        self.view.addSubview(secondImageView)
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        secondImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        secondImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupQuickCreationLabel() {
        self.view.addSubview(quickCreationLabel)
        quickCreationLabel.translatesAutoresizingMaskIntoConstraints = false
        quickCreationLabel.leftAnchor.constraint(equalTo: self.secondImageView.rightAnchor, constant: 15).isActive = true
        quickCreationLabel.bottomAnchor.constraint(equalTo: self.secondImageView.topAnchor, constant: -20).isActive = true
        
    }
    
    func setupQuickCreationDescriptionLabel() {
        self.view.addSubview(quickCreationDescriptionLabel)
        quickCreationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        quickCreationDescriptionLabel.leftAnchor.constraint(equalTo: self.quickCreationLabel.leftAnchor).isActive = true
        quickCreationDescriptionLabel.topAnchor.constraint(equalTo: self.quickCreationLabel.bottomAnchor, constant: 3).isActive = true
    }
    
    func setupUpvoteLabel() {
        self.view.addSubview(upvoteLabel)
        upvoteLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteLabel.leftAnchor.constraint(equalTo: self.quickCreationLabel.leftAnchor).isActive = true
        upvoteLabel.topAnchor.constraint(equalTo: self.quickCreationDescriptionLabel.bottomAnchor, constant: 25).isActive = true
    }
    
    func setupUpvoteDescriptionLabel() {
        self.view.addSubview(upvoteDescriptionLabel)
        upvoteDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteDescriptionLabel.leftAnchor.constraint(equalTo: self.quickCreationLabel.leftAnchor).isActive = true
        upvoteDescriptionLabel.topAnchor.constraint(equalTo: self.upvoteLabel.bottomAnchor, constant: 3).isActive = true
    }
    
    func setupThirdImageView() {
        thirdImageView.layer.cornerRadius = 10
        thirdImageView.layer.masksToBounds = true
        self.view.addSubview(thirdImageView)
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        thirdImageView.centerYAnchor.constraint(equalTo: self.upvoteDescriptionLabel.centerYAnchor).isActive = true
        thirdImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        thirdImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupNewFeaturesDescriptionLabel() {
        self.view.addSubview(newFeaturesDescriptionLabel)
        newFeaturesDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newFeaturesDescriptionLabel.leftAnchor.constraint(equalTo: self.quickCreationLabel.leftAnchor).isActive = true
        newFeaturesDescriptionLabel.bottomAnchor.constraint(equalTo: self.quickCreationLabel.topAnchor, constant: -25).isActive = true
    }
    
    func setupNewFeaturesLabel() {
        self.view.addSubview(newFeaturesLabel)
        newFeaturesLabel.translatesAutoresizingMaskIntoConstraints = false
        newFeaturesLabel.leftAnchor.constraint(equalTo: self.quickCreationLabel.leftAnchor).isActive = true
        newFeaturesLabel.bottomAnchor.constraint(equalTo: self.newFeaturesDescriptionLabel.topAnchor, constant: -3).isActive = true
    }
    
    func setupFirstImageView() {
        firstImageView.layer.cornerRadius = 10
        firstImageView.layer.masksToBounds = true
        self.view.addSubview(firstImageView)
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        firstImageView.centerYAnchor.constraint(equalTo: self.newFeaturesDescriptionLabel.centerYAnchor).isActive = true
        firstImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCcontinueButton() {
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension WelcomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[.originalImage] as? UIImage {
            
            
            picker.dismiss(animated: true, completion: nil)
            
            
            guard let ImageCIo = CIImage(image: image) else { // Convert to a core image
                fatalError("couldn't convert uiimage to CIImage")
            }
            DispatchQueue.global(qos: .userInitiated).async {
                self.presenter.view?.hotdogClassifier(image: ImageCIo)
            }
        }
    }
}

//MARK: - Presenter Protocol Declaration
extension WelcomeViewController: WelcomeViewControllerPresenterView {
    
    func hotdogClassifier(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Unable to load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let output = request.results as? [VNClassificationObservation],
                let bestResult = output.first
                else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            print("Prediction: \(bestResult.identifier). Confidence: \(bestResult.confidence)")
            if (bestResult.identifier.contains("hotdog") && bestResult.confidence > 0.2) {
                DispatchQueue.main.async {
                    print("1")
                    let vc = FilterViewController(image: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                    print("2")
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Only Hot-Dog photoes applied!", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                               self.present(alert, animated: true)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do { try handler.perform([request]) }
        catch {
            }
        
    }
    
    func showPicker() {
        self.present(imageFinder, animated: true, completion: nil)
    }
}
