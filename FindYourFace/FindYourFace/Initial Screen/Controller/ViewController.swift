//
//  ViewController.swift
//  FindYourFace
//
//  Created by Roman on 8/18/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
 

class ViewController: UIViewController {

    lazy var presenter = ViewControllerPresenter(with: self)
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Make Your Custom Hotdog"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name:"ChalkboardSE-Bold",size:25.0)
        label.textAlignment = .center
        label.textColor = UIColor(red: 60/255, green: 60/255, blue: 83/255, alpha: 1.0)
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
           let label = UILabel()
        label.font = UIFont(name:"ChalkboardSE-Bold",size:15.0)
           label.text = "This is a professional and fun social app to bring you more networking pleasure through shares accurately image data, activities and routes. More social activities for you to take part in."
        label.numberOfLines = 0
           label.textAlignment = .center
           label.textColor = UIColor(red: 60/255, green: 60/255, blue: 83/255, alpha: 0.8)
           return label
       }()
    
   
    fileprivate let startButton:UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont(name:"ChalkboardSE-Bold",size:23.0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupBackground()
        setupTitleLabel()
        setupDescriptionLabel()
        setupStartButton()
    }
    
    @objc func moveVC() {
        presenter.view?.presentVC()
    }
}

//MARK: - UI Configuration
extension ViewController {
    func setupNavigationController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18.0)]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupBackground() {
        self.view.addBackground(name: "backgroundWelcomeApp2.jpg")
    }
    
    func setupTitleLabel() {
        self.view.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 55).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -55).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
    }
    
    func setupDescriptionLabel() {
        self.view.addSubview(descriptionLabel)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -22).isActive = true
        self.descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 70).isActive = true
    }
    
    func setupStartButton() {
        self.view.addSubview(startButton)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 55).isActive = true
        self.startButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -55).isActive = true
        self.startButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50).isActive = true
        self.startButton.backgroundColor = UIColor(red: 105/255, green: 190/255, blue: 247/255, alpha: 1.0)
        self.startButton.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
    }
}

//MARK: - Presenter Protocol Declaration
extension ViewController: ViewControllerPresenterView {
    func presentVC() {
        let vc = RegistrationController()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIView {
    func addBackground(name:String) {
    // screen width and height:

    let imageViewBackground = UIImageView()
    imageViewBackground.image = UIImage(named: name)
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
        
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        imageViewBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageViewBackground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageViewBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageViewBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
}}

