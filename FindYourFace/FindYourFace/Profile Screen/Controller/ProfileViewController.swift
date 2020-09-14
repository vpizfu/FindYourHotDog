//
//  ProfileViewController.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfileViewController: UIViewController {
    
    lazy var presenter = ProfileViewControllerPresenter(with: self)
    
    let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
    let saveQueue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
    
    var managedContext : NSManagedObjectContext?
    
    var ahievementArray = [UIImage]()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cat")
        return imageView
    }()
    
    let fullname: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your full Name"
        return textField
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 10.0)
        label.text = "FULL NAME"
        label.textColor = .black
        return label
    }()
    
    let fullnameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    let nickName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your nick name"
        return textField
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 10.0)
        label.text = "NICK NAME"
        return label
    }()
    
    let nickSeporatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    let email: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        return textField
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 10.0)
        label.text = "EMAIL"
        label.textColor = .black
        return label
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let achievementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 10.0)
        label.text = "ACHIEVEMENT"
        label.textColor = .black
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.5
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        return button
    }()
    
    let achievementView = UIView()
    
    var achievementCollectionView: UICollectionView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchAchievements()
        self.view.backgroundColor = .white
        presenter.view?.coreDataSetup()
        presenter.view?.loadImageFromCoreData()
        setupLogoImageView()
        setupAchievementCollectionView()
        setupAchievementLabel()
        setupAchievementView()
        setupFullNameLabel()
        setupFullName()
        setupFullNameSeparatorView()
        setupNickNameLabel()
        setupNickName()
        setupNiceSeparatorView()
        setupEmailLabel()
        setupEnail()
        setupEmailSeparatorView()
        setupConfrimButton()
        setupTapGestureRecognizer()
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAchievements()
    }
    
    func fetchAchievements() {
        let wolfFlag = UserDefaults.standard.bool(forKey: "wolf")
        let dragonFlag = UserDefaults.standard.bool(forKey: "dragon")
        let hotDogFlag = UserDefaults.standard.bool(forKey: "Hotdog")
        
        ahievementArray.removeAll()
        
        if (wolfFlag) {
            ahievementArray.append(UIImage(named: "wolf")!)
        }
        
        if (dragonFlag) {
            ahievementArray.append(UIImage(named: "dragon")!)
        }
        
        if (hotDogFlag) {
            ahievementArray.append(UIImage(named: "hotdog")!)
        }
        
        self.achievementCollectionView?.reloadData()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        presenter.view?.showImagePicker()
    }
    
    
    @objc func updateData() {
        presenter.view?.saveDataToFirebase()
    }
}

//MARK: - UI Configuration
extension ProfileViewController {
    func setupLogoImageView() {
        self.view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 35).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    }
    
    func setupAchievementCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        achievementCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        achievementCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        achievementCollectionView?.backgroundColor = .white
        achievementView.addSubview(achievementCollectionView!)
        achievementCollectionView?.dataSource = self
        achievementCollectionView?.delegate = self
        
        achievementCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        achievementCollectionView?.leftAnchor.constraint(equalTo: achievementView.leftAnchor).isActive = true
        achievementCollectionView?.rightAnchor.constraint(equalTo: achievementView.rightAnchor).isActive = true
        achievementCollectionView?.topAnchor.constraint(equalTo: achievementView.topAnchor).isActive = true
        achievementCollectionView?.bottomAnchor.constraint(equalTo: achievementView.bottomAnchor).isActive = true
    }
    
    
    func setupAchievementLabel() {
        self.view.addSubview(achievementLabel)
        achievementLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor).isActive = true
        achievementLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 30).isActive = true
    }
    func setupAchievementView() {
        self.view.addSubview(achievementView)
        achievementView.translatesAutoresizingMaskIntoConstraints = false
        achievementView.topAnchor.constraint(equalTo: achievementLabel.bottomAnchor, constant: 5).isActive = true
        achievementView.leftAnchor.constraint(equalTo: achievementLabel.leftAnchor).isActive = true
        achievementView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
        achievementView.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
    }
    
    func setupFullNameLabel() {
        self.view.addSubview(fullnameLabel)
        fullnameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: logoImageView.leftAnchor).isActive = true
    }
    
    func setupFullName() {
        self.view.addSubview(fullname)
        fullname.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 15).isActive = true
        fullname.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
        fullname.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -35).isActive = true
    }
    
    func setupFullNameSeparatorView() {
        self.view.addSubview(fullnameSeparatorView)
        fullnameSeparatorView.topAnchor.constraint(equalTo: fullname.bottomAnchor, constant: 15).isActive = true
        fullnameSeparatorView.leftAnchor.constraint(equalTo: fullname.leftAnchor).isActive = true
        fullnameSeparatorView.rightAnchor.constraint(equalTo: fullname.rightAnchor).isActive = true
        fullnameSeparatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    
    func setupNickNameLabel() {
        self.view.addSubview(nickNameLabel)
        nickNameLabel.topAnchor.constraint(equalTo: fullnameSeparatorView.bottomAnchor, constant: 30).isActive = true
        nickNameLabel.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
    }
    
    func setupNickName() {
        self.view.addSubview(nickName)
        nickName.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 15).isActive = true
        nickName.leftAnchor.constraint(equalTo: nickNameLabel.leftAnchor).isActive = true
        nickName.rightAnchor.constraint(equalTo: fullname.rightAnchor).isActive = true
    }
    
    func setupNiceSeparatorView() {
        self.view.addSubview(nickSeporatorView)
        nickSeporatorView.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 15).isActive = true
        nickSeporatorView.leftAnchor.constraint(equalTo: nickName.leftAnchor).isActive = true
        nickSeporatorView.rightAnchor.constraint(equalTo: nickName.rightAnchor).isActive = true
        nickSeporatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    func setupEmailLabel() {
        self.view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: nickSeporatorView.bottomAnchor, constant: 30).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: fullnameLabel.leftAnchor).isActive = true
    }
    
    func setupEnail() {
        self.view.addSubview(email)
        email.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15).isActive = true
        email.leftAnchor.constraint(equalTo: emailLabel.leftAnchor).isActive = true
        email.rightAnchor.constraint(equalTo: fullname.rightAnchor).isActive = true
    }
    
    func setupEmailSeparatorView() {
        self.view.addSubview(emailSeparatorView)
        emailSeparatorView.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 15).isActive = true
        emailSeparatorView.leftAnchor.constraint(equalTo: email.leftAnchor).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: email.rightAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    func setupConfrimButton() {
        self.view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.leftAnchor.constraint(equalTo: emailSeparatorView.leftAnchor).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: emailSeparatorView.rightAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
}

//MARK: - Presenter Protocol Declaration
extension ProfileViewController: ProfileViewControllerPresenterView {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func saveDataToFirebase() {
        let databaseRef = Database.database().reference().child("images").child(Auth.auth().currentUser!.uid)
        if !(nickName.text!.isEmpty) {
            databaseRef.updateChildValues(["name": nickName.text as Any])
        }
        if !(fullname.text!.isEmpty) {
            databaseRef.updateChildValues(["fullName": fullname.text as Any])
        }
        if !(email.text!.isEmpty) {
            databaseRef.updateChildValues(["email": email.text as Any])
        }
    }
    
    func loadImageFromCoreData() { // button action
        print("1")
        loadImages { (images) -> Void in
            print("2")
            if let thumbnailData = images?.last?.thumbnail?.imageData {
                print("3")
                let image = UIImage(data: thumbnailData)
                self.logoImageView.image = image
            } else {
                DispatchQueue.global().async {
                    ImageNetworking().fetchLogoFromFirebase { (image, error) in
                        if (error == nil) {
                            self.logoImageView.image = image
                            self.prepareImageForSaving(image: image!)
                        } else {
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                           self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func coreDataSetup() {
        saveQueue.sync() {
            self.managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    private func prepareImageForSaving(image:UIImage) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        // dispatch with gcd.
        convertQueue.async() {
            
            // create NSData from UIImage
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            
            // scale image, I chose the size of the VC because it is easy
            let thumbnail = image
            
            guard let thumbnailData  = thumbnail.jpegData(compressionQuality: 0.7) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData: imageData, thumbnailData: thumbnailData, date: date)
            
        }
    }
    
    private func saveImage(imageData:Data, thumbnailData:Data, date: Double) {
        
        saveQueue.sync {
            // create new objects in moc
            guard let moc = self.managedContext else {
                return
            }
            
            guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: "FullRes", into: moc) as? FullRes, let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: moc) as? Thumbnail else {
                // handle failed new object in moc
                print("moc error")
                return
            }
            
            //set image data of fullres
            fullRes.imageData = imageData as Data
            
            //set image data of thumbnail
            thumbnail.imageData = thumbnailData as Data
            thumbnail.id = date
            thumbnail.fullRes = fullRes
            
            // save the new objects
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // clear the moc
            moc.refreshAllObjects()
        }
    }
    
    
    private func loadImages(fetched: @escaping (_ images:[FullRes]?) -> Void) {
        
        saveQueue.async() {
            print("1.0")
            guard let moc = self.managedContext else {
                return
            }
            print("1.1")
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FullRes")
            
            do {
                print("1.2")
                let results = try moc.fetch(fetchRequest)
                let imageData = results as? [FullRes]
                DispatchQueue.main.async {
                    fetched(imageData)
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                return
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.global(qos: .utility).async {
                ImageNetworking().uploadPhoto(image: image, profile: true, completion: {(error) in
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                   self.present(alert, animated: true)
                })
            }
            self.logoImageView.image = image
            prepareImageForSaving(image: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Count: \(ahievementArray.count)")
        return ahievementArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        
        
        let imageView = UIImageView(image: ahievementArray[indexPath.row])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        
        myCell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: myCell.contentView.leftAnchor, constant: 2).isActive = true
         imageView.rightAnchor.constraint(equalTo: myCell.contentView.rightAnchor, constant: -2).isActive = true
         imageView.topAnchor.constraint(equalTo: myCell.contentView.topAnchor, constant: 2).isActive = true
         imageView.bottomAnchor.constraint(equalTo: myCell.contentView.bottomAnchor, constant: -2).isActive = true
    
        //myCell.backgroundColor = UIColor.blue
        return myCell
    }
}

//MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 30, height: 30)
    }
}

extension CGSize {
    
    func resizeFill(toSize: CGSize) -> CGSize {
        
        let scale : CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        return CGSize(width: (self.width / scale), height: (self.height / scale))
        
    }
}

extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = self.size.resizeFill(toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: aspectFill.width, height: aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
