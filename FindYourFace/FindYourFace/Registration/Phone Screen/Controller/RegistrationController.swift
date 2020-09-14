//
//  RegistrationController.swift
//  FindYourFace
//
//  Created by Roman on 8/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationController: UIViewController {

    lazy var presenter = RegistrationControllerPresenter(with: self)
    
    fileprivate let underline = UIView()
    fileprivate let imageView = UIImageView(image: UIImage(named:"PCPhone"))
    fileprivate var customSC = UISegmentedControl()
    
    
    fileprivate let registrationFormView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let startButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NextButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    fileprivate let labelPersonalInfo:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Black", size: 16.0)
        label.text = "Personal information"
        label.textColor = .black
        return label
    }()
    
    fileprivate let firstViewTemp: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone"
        textField.textColor = .black
        return textField
    }()
    
    fileprivate let firstViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Black", size: 14.0)
        label.text = "Your Phone Number"
        label.textColor = UIColor(red: 68/255, green: 79/255, blue: 219/255, alpha: 1.0)
        return label
    }()
    
    fileprivate let secondViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate let firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText =
            NSMutableAttributedString()
                .normal("We will send you ")
                .bold("ONE")
                .normal(" time SMS message,")
        label.textColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1.0)
        return label
    }()
    
    fileprivate let secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.text = "Carrier rates may apply"
        label.textColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1.0)
        return label
    }()
    
    fileprivate let secondViewTmp: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupBackground()
        setupRefistrationFormView()
        setupLabelPersonalInfo()
        setupFirstViewTmp()
        setupImageView()
        setupPhoneTextField()
        setupFirstViewLine()
        setupPhoneNumberLabel()
        setupSecondViewLine()
        setupFirstDescriptionLabel()
        setupSecondDescriptionLabel()
        setupSecondViewTmp()
        setupStartButton()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    fileprivate func setupNotifications() {
        presenter.view?.setupKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        presenter.view?.showKeyboard(notification: notification)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        presenter.view?.hideKeyboard()
    }

    @objc func actionButton() {
        presenter.view?.authViaPhone()
    }
}

//MARK: - UI Configuration
extension RegistrationController {
    func setupNavigationController() {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 18.0) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Send Code"
    }
    
    func setupBackground() {
        self.view.addBackground(name: "backgroundWelcomeApp.png")
    }
    
    func setupRefistrationFormView() {
        self.view.addSubview(registrationFormView)
        registrationFormView.translatesAutoresizingMaskIntoConstraints = false
        registrationFormView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        registrationFormView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        registrationFormView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -70).isActive = true
        registrationFormView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupLabelPersonalInfo() {
        registrationFormView.addSubview(labelPersonalInfo)
        labelPersonalInfo.translatesAutoresizingMaskIntoConstraints = false
        labelPersonalInfo.topAnchor.constraint(equalTo: registrationFormView.topAnchor, constant: 30).isActive = true
        labelPersonalInfo.leftAnchor.constraint(equalTo: registrationFormView.leftAnchor, constant: 25).isActive = true
        labelPersonalInfo.rightAnchor.constraint(equalTo: registrationFormView.rightAnchor, constant: -25).isActive = true
        labelPersonalInfo.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupFirstViewTmp() {
        self.view.addSubview(firstViewTemp)
        firstViewTemp.translatesAutoresizingMaskIntoConstraints = false
        firstViewTemp.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        firstViewTemp.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        firstViewTemp.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        firstViewTemp.bottomAnchor.constraint(equalTo: self.registrationFormView.topAnchor).isActive = true
    }
    
    func setupImageView() {
        firstViewTemp.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 77).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerYAnchor.constraint(equalTo: firstViewTemp.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: firstViewTemp.centerXAnchor).isActive = true
    }
    
    func setupPhoneTextField() {
        self.registrationFormView.addSubview(phoneTextField)
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.topAnchor.constraint(equalTo: labelPersonalInfo.bottomAnchor, constant: 40).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: labelPersonalInfo.leftAnchor).isActive = true
        phoneTextField.rightAnchor.constraint(equalTo: labelPersonalInfo.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupFirstViewLine() {
        self.registrationFormView.addSubview(firstViewLine)
        firstViewLine.translatesAutoresizingMaskIntoConstraints = false
        firstViewLine.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 8).isActive = true
        firstViewLine.leftAnchor.constraint(equalTo: phoneTextField.leftAnchor).isActive = true
        firstViewLine.rightAnchor.constraint(equalTo: phoneTextField.rightAnchor).isActive = true
        firstViewLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    func setupPhoneNumberLabel() {
        registrationFormView.addSubview(phoneNumberLabel)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.topAnchor.constraint(equalTo: firstViewLine.bottomAnchor, constant: 25).isActive = true
        phoneNumberLabel.leftAnchor.constraint(equalTo: firstViewLine.leftAnchor).isActive = true
        phoneNumberLabel.rightAnchor.constraint(equalTo: firstViewLine.rightAnchor).isActive = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupSecondViewLine() {
        self.registrationFormView.addSubview(secondViewLine)
               secondViewLine.translatesAutoresizingMaskIntoConstraints = false
               secondViewLine.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 15).isActive = true
               secondViewLine.leftAnchor.constraint(equalTo: phoneNumberLabel.leftAnchor).isActive = true
               secondViewLine.rightAnchor.constraint(equalTo: phoneNumberLabel.rightAnchor).isActive = true
               secondViewLine.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
    }
    
    func setupFirstDescriptionLabel() {
        registrationFormView.addSubview(firstDescriptionLabel)
        firstDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        firstDescriptionLabel.topAnchor.constraint(equalTo: secondViewLine.bottomAnchor, constant: 40).isActive = true
        firstDescriptionLabel.leftAnchor.constraint(equalTo: secondViewLine.leftAnchor, constant: 5).isActive = true
        firstDescriptionLabel.rightAnchor.constraint(equalTo: secondViewLine.rightAnchor, constant: -5).isActive = true
        firstDescriptionLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func setupSecondDescriptionLabel() {
        registrationFormView.addSubview(secondDescriptionLabel)
        secondDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        secondDescriptionLabel.topAnchor.constraint(equalTo: firstDescriptionLabel.bottomAnchor, constant: 5).isActive = true
        secondDescriptionLabel.leftAnchor.constraint(equalTo: firstDescriptionLabel.leftAnchor).isActive = true
        secondDescriptionLabel.rightAnchor.constraint(equalTo: firstDescriptionLabel.rightAnchor).isActive = true
        secondDescriptionLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    func setupSecondViewTmp() {
           self.view.addSubview(secondViewTmp)
           secondViewTmp.translatesAutoresizingMaskIntoConstraints = false
           secondViewTmp.topAnchor.constraint(equalTo: secondDescriptionLabel.bottomAnchor).isActive = true
           secondViewTmp.leftAnchor.constraint(equalTo: self.registrationFormView.leftAnchor).isActive = true
           secondViewTmp.rightAnchor.constraint(equalTo: self.registrationFormView.rightAnchor).isActive = true
           secondViewTmp.bottomAnchor.constraint(equalTo: self.registrationFormView.bottomAnchor).isActive = true
    }
    
    func setupStartButton() {
           secondViewTmp.addSubview(startButton)
           self.startButton.translatesAutoresizingMaskIntoConstraints = false
           self.startButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
           self.startButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
           self.startButton.centerXAnchor.constraint(equalTo: secondViewTmp.centerXAnchor).isActive = true
           self.startButton.centerYAnchor.constraint(equalTo: secondViewTmp.centerYAnchor).isActive = true
           self.startButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
}

//MARK: - Presenter Protocol Declaration
extension RegistrationController: RegistrationControllerPresenterView {
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func showKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y == 0 {
                       self.view.frame.origin.y -= keyboardSize.height
                   }
            }
    }
    
    func authViaPhone() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneTextField.text!, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let vc = CodeConfirmationController()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem?.tintColor = .black
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UISegmentedControl {
    func removeBorder() {
        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name:"ChalkboardSE-Bold",size:21.0) as Any, NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
    }
    
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
           let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
           UIGraphicsBeginImageContext(rect.size)
           let context = UIGraphicsGetCurrentContext()
           context!.setFillColor(color.cgColor);
           context!.fill(rect);
           let image = UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
           return image!
       }
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
