//
//  FilterViewController.swift
//  FindYourFace
//
//  Created by Roman on 9/4/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit


class FilterViewController: UIViewController {
    
    lazy var presenter = FilterViewControllerPresenter(with: self)
    
    
    let button: UIButton = {
        let tmpButton = UIButton()
        tmpButton.setTitle("Change Filter", for: .normal)
        tmpButton.backgroundColor = UIColor.systemBlue
        tmpButton.layer.cornerRadius = 15
        tmpButton.layer.masksToBounds = true
        tmpButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        tmpButton.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 18)
        return tmpButton
    }()
    
    var image: CIImage?
    let imageView = UIImageView()
    var count = 1
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = .white
        imageView.image = image?.convert()
        imageView.contentMode = .scaleAspectFill
        setupRighBarButtonItem()
        setupImageView()
        setupButton()
    }
    
    @objc func applyFilter() {
        presenter.view?.applyCustomFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    
    init(image: CIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func saveImage() {
        presenter.view?.saveOurImage()
    }
}

//MARK: - UI Configuration
extension FilterViewController {
    func setupRighBarButtonItem() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveImage))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Default"
    }
    
    func setupButton() {
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    }
    
    func setupImageView() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: - Presenter Protocol Declaration
extension FilterViewController: FilterViewControllerPresenterView {
    func applyCustomFilter() {
        switch count {
        case 1:
            self.navigationItem.title = "Chrome"
            imageView.image = image?.addFilter(filter: .Chrome)
            count += 1
        case 2:
            self.navigationItem.title = "Fade"
            imageView.image = image?.addFilter(filter: .Fade)
            count += 1
        case 3:
            self.navigationItem.title = "Instant"
            imageView.image = image?.addFilter(filter: .Instant)
            count += 1
        case 4:
            self.navigationItem.title = "Mono"
            imageView.image = image?.addFilter(filter: .Mono)
            count += 1
        case 5:
            self.navigationItem.title = "Noir"
            imageView.image = image?.addFilter(filter: .Noir)
            count += 1
        case 6:
            self.navigationItem.title = "Process"
            imageView.image = image?.addFilter(filter: .Process)
            count += 1
        case 7:
            self.navigationItem.title = "Tonal"
            imageView.image = image?.addFilter(filter: .Tonal)
            count += 1
        case 8:
            self.navigationItem.title = "Transfer"
            imageView.image = image?.addFilter(filter: .Transfer)
            count = 0
        default:
            self.navigationItem.title = "Default"
            imageView.image = image?.convert()
            count += 1
        }
    }
    
    func saveOurImage() {
        let image = self.imageView.image!
        DispatchQueue.global(qos: .utility).async {
            ImageNetworking().uploadPhoto(image: image, profile: false, completion: {(error) in
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        }
        showTabBarController()
    }
    
    private func showTabBarController() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension CIImage {
    
    enum FilterType : String {
        case Chrome = "CIPhotoEffectChrome"
        case Fade = "CIPhotoEffectFade"
        case Instant = "CIPhotoEffectInstant"
        case Mono = "CIPhotoEffectMono"
        case Noir = "CIPhotoEffectNoir"
        case Process = "CIPhotoEffectProcess"
        case Tonal = "CIPhotoEffectTonal"
        case Transfer =  "CIPhotoEffectTransfer"
    }
    
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        filter?.setValue(self, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
    
    func convert() -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(self, from: self.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

