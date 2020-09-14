//
//  CodeConfirmationController.swift
//  FindYourFace
//
//  Created by Roman on 8/22/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import FirebaseAuth

class CodeConfirmationController: UIViewController {

    lazy var presenter = CodeConfirmationPresenter(with: self)
    
    var otpText = String()
    
    let numberOneLabel = UITextField()
    let numberTwoLabel = UITextField()
    let numberThreeLabel = UITextField()
    let numberFourthLabel = UITextField()
    let numberFiveLabel = UITextField()
    let numberSixLabel = UITextField()
    
    let resendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Light", size: 10.0)
        label.text = "RESEND CODE"
        label.textColor = .white
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow.png")
        return imageView
    }()
    
    let codeView: UIView = {
        let view = UIView()
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 1.5
    view.layer.cornerRadius = 8
        return view
    }()
    
    let tmpView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let tickImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(named: "tick.png")
           return imageView
       }()
    
    let confirmationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Black", size: 16.0)
        label.text = "CONFIRMATION"
        label.textColor = .white
        return label
    }()
    
    let tmpView2:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "phone.png")
        return imageView
    }()
    
    let phoneInfoLabel: UILabel = {
        let label = UILabel()
    label.numberOfLines = 2
    label.textColor = .white
    label.font = UIFont(name: "Lato-Black", size: 14.0)
    let tmpString = NSMutableAttributedString.init(string: "Please type the verification code sent to +375 44 *** ** 11")
        tmpString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Lato", size: 14.0) as Any],
                             range: NSMakeRange(0, 41))
    label.attributedText = tmpString
        return label
    }()
    
    let confirmationButton: UIButton = {
        let button = UIButton()
    button.setImage(UIImage(named: "confirmButton.png"), for: .normal)
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(signInWithCode), for: .touchUpInside)
        return button
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupBackground()
        setupResendLabel()
        setupArrowImageView()
        setupCodeView()
        setupTmpView()
        setupTickImageView()
        setupConfirmationLabel()
        setupTmpView2()
        setupPhoneImageView()
        setupPhoneInfoLabel()
        setupCodeTextFields()
        setupConfrimationButton()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.presenter.view?.parseCode(textField: textField)
    }
    
    @objc func signInWithCode() {
        self.presenter.view?.authWithSms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Verification Code"
    }
    
}

//MARK: - UI Configuration
extension CodeConfirmationController {
    func setupResendLabel() {
        self.view.addSubview(resendLabel)
        resendLabel.translatesAutoresizingMaskIntoConstraints = false
        resendLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        resendLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
    }
    
    func setupArrowImageView() {
        self.view.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.centerYAnchor.constraint(equalTo: resendLabel.centerYAnchor).isActive = true
        arrowImageView.leftAnchor.constraint(equalTo: resendLabel.rightAnchor, constant: 8).isActive = true
    }
    
    func setupCodeView() {
        self.view.addSubview(codeView)
        codeView.translatesAutoresizingMaskIntoConstraints = false
        codeView.leftAnchor.constraint(equalTo: resendLabel.leftAnchor).isActive = true
        codeView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        codeView.bottomAnchor.constraint(equalTo: resendLabel.topAnchor, constant: -10).isActive = true
        codeView.heightAnchor.constraint(equalToConstant: 86).isActive = true
    }
    
    func setupTmpView() {
        self.view.addSubview(tmpView)
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        tmpView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tmpView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tmpView.bottomAnchor.constraint(equalTo: codeView.topAnchor).isActive = true
        tmpView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func setupTickImageView() {
        tmpView.addSubview(tickImageView)
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.leftAnchor.constraint(equalTo: codeView.leftAnchor).isActive = true
        tickImageView.topAnchor.constraint(equalTo: tmpView.centerYAnchor).isActive = true
    }
    
    func setupConfirmationLabel() {
        tmpView.addSubview(confirmationLabel)
        confirmationLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmationLabel.centerYAnchor.constraint(equalTo: tickImageView.centerYAnchor, constant: -1).isActive = true
        confirmationLabel.leftAnchor.constraint(equalTo: tickImageView.rightAnchor, constant: 8).isActive = true
    }
    
    func setupTmpView2() {
        tmpView.addSubview(tmpView2)
               tmpView2.translatesAutoresizingMaskIntoConstraints = false
               tmpView2.leftAnchor.constraint(equalTo: tmpView.leftAnchor).isActive = true
               tmpView2.rightAnchor.constraint(equalTo: tmpView.rightAnchor).isActive = true
               tmpView2.bottomAnchor.constraint(equalTo: tmpView.bottomAnchor).isActive = true
        tmpView2.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor).isActive = true
    }
    
    func setupPhoneImageView() {
        tmpView2.addSubview(phoneImageView)
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
        phoneImageView.leftAnchor.constraint(equalTo: tickImageView.leftAnchor).isActive = true
        phoneImageView.centerYAnchor.constraint(equalTo: tmpView2.centerYAnchor).isActive = true
    }
    
    func setupPhoneInfoLabel() {
        tmpView2.addSubview(phoneInfoLabel)
        phoneInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneInfoLabel.centerYAnchor.constraint(equalTo: phoneImageView.centerYAnchor).isActive = true
        phoneInfoLabel.leftAnchor.constraint(equalTo: phoneImageView.rightAnchor, constant: 15).isActive = true
        phoneInfoLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    func setupConfrimationButton() {
        self.view.addSubview(confirmationButton)
        confirmationButton.translatesAutoresizingMaskIntoConstraints = false
        confirmationButton.leftAnchor.constraint(equalTo: codeView.leftAnchor).isActive = true
        confirmationButton.rightAnchor.constraint(equalTo: codeView.rightAnchor).isActive = true
        confirmationButton.topAnchor.constraint(equalTo: resendLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setupCodeTextFields() {
                let width = (UIScreen.main.bounds.width - 53 - 91) / 6
                numberOneLabel.delegate = self
               numberOneLabel.keyboardType = .numberPad
               numberOneLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberOneLabel.layer.masksToBounds = true
               numberOneLabel.layer.cornerRadius = 5
               numberOneLabel.textColor = .white
               numberOneLabel.textAlignment = .center
               numberOneLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               numberOneLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               codeView.addSubview(numberOneLabel)
               numberOneLabel.translatesAutoresizingMaskIntoConstraints = false
               numberOneLabel.leftAnchor.constraint(equalTo: codeView.leftAnchor, constant: 13).isActive = true
               numberOneLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberOneLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberOneLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
               
               
               numberTwoLabel.delegate = self
               numberTwoLabel.keyboardType = .numberPad
               numberTwoLabel.layer.cornerRadius = 5
               numberTwoLabel.layer.masksToBounds = true
               numberTwoLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberTwoLabel.textColor = .white
               numberTwoLabel.textAlignment = .center
               numberTwoLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               numberTwoLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               codeView.addSubview(numberTwoLabel)
               numberTwoLabel.translatesAutoresizingMaskIntoConstraints = false
               numberTwoLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 13).isActive = true
               numberTwoLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberTwoLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberTwoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
               
               
               numberThreeLabel.keyboardType = .numberPad
               numberThreeLabel.delegate = self
               numberThreeLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               numberThreeLabel.layer.masksToBounds = true
               numberThreeLabel.layer.cornerRadius = 5
               numberThreeLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberThreeLabel.textColor = .white
               numberThreeLabel.textAlignment = .center
               numberThreeLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               codeView.addSubview(numberThreeLabel)
               numberThreeLabel.translatesAutoresizingMaskIntoConstraints = false
               numberThreeLabel.leftAnchor.constraint(equalTo: numberTwoLabel.rightAnchor, constant: 13).isActive = true
               numberThreeLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberThreeLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberThreeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
               
               
               numberFourthLabel.keyboardType = .numberPad
               numberFourthLabel.delegate = self
               numberFourthLabel.layer.cornerRadius = 5
               numberFourthLabel.layer.masksToBounds = true
               numberFourthLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberFourthLabel.textColor = .white
               numberFourthLabel.textAlignment = .center
               numberFourthLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               numberFourthLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               codeView.addSubview(numberFourthLabel)
               numberFourthLabel.translatesAutoresizingMaskIntoConstraints = false
               numberFourthLabel.leftAnchor.constraint(equalTo: numberThreeLabel.rightAnchor, constant: 13).isActive = true
               numberFourthLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberFourthLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberFourthLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
               
               
               numberFiveLabel.keyboardType = .numberPad
               numberFiveLabel.delegate = self
               numberFiveLabel.layer.cornerRadius = 5
               numberFiveLabel.layer.masksToBounds = true
               numberFiveLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberFiveLabel.textColor = .white
               numberFiveLabel.textAlignment = .center
               numberFiveLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               numberFiveLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               codeView.addSubview(numberFiveLabel)
               numberFiveLabel.translatesAutoresizingMaskIntoConstraints = false
               numberFiveLabel.leftAnchor.constraint(equalTo: numberFourthLabel.rightAnchor, constant: 13).isActive = true
               numberFiveLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberFiveLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberFiveLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
           
               numberSixLabel.keyboardType = .numberPad
               numberSixLabel.delegate = self
               numberSixLabel.layer.masksToBounds = true
               numberSixLabel.layer.cornerRadius = 5
               numberSixLabel.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
               numberSixLabel.textColor = .white
               numberSixLabel.textAlignment = .center
               numberSixLabel.font = UIFont(name: "Lato-Black", size: 30.0)
               numberSixLabel.attributedPlaceholder = NSAttributedString(string: "-",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 30.0) as Any])
               codeView.addSubview(numberSixLabel)
               numberSixLabel.translatesAutoresizingMaskIntoConstraints = false
               numberSixLabel.leftAnchor.constraint(equalTo: numberFiveLabel.rightAnchor, constant: 13).isActive = true
               numberSixLabel.centerYAnchor.constraint(equalTo: codeView.centerYAnchor).isActive = true
               numberSixLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
               numberSixLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
               
               numberOneLabel.addTarget(self, action:#selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func setupBackground() {
        self.view.addBackground(name: "backgroundWelcomeApp3.png")
    }
}

//MARK: - Presenter Protocol Declaration
extension CodeConfirmationController: CodeConfirmationPresenterView {
    func parseCode(textField: UITextField) {
        if let otpCode = textField.text ,  otpCode.count > 5 {
            numberOneLabel.text = String(otpCode[otpCode.startIndex])
            numberTwoLabel.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 1)])
            numberThreeLabel.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 2)])
            numberFourthLabel.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 3)])
            numberFiveLabel.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 4)])
            numberSixLabel.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: 5)])
            numberOneLabel.isUserInteractionEnabled = false
            numberTwoLabel.isUserInteractionEnabled = false
            numberThreeLabel.isUserInteractionEnabled = false
            numberFourthLabel.isUserInteractionEnabled = false
            numberFiveLabel.isUserInteractionEnabled = false
            numberSixLabel.isUserInteractionEnabled = false
            self.view.endEditing(true)
        }
    }
    
    func authWithSms() {
        view.endEditing(true)
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        let verificationCode = "\(numberOneLabel.text! + numberTwoLabel.text! + numberThreeLabel.text! + numberFourthLabel.text! + numberFiveLabel.text! + numberSixLabel.text!)"
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            //UserDefaults.standard.set(verificationID, forKey: "uuid")
            let vc = WelcomeViewController()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: true, completion: nil)
           
        }
    }
    
    
}

//MARK: - UITextFieldDelegate
extension CodeConfirmationController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        textField.backgroundColor = .white
        textField.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "-"
        textField.backgroundColor = UIColor(red: 116/255, green: 125/255, blue: 229/255, alpha: 1.0)
        textField.textColor = .white
    }
}
