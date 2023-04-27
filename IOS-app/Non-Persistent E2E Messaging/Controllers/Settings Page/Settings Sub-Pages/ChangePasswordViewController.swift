//
//  ChangePasswordViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 4/25/23.
//

import UIKit
import XMPPFramework
import KeychainSwift

class ChangePasswordViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    //Used to access default values
    let defaults = UserDefaults.standard

    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        calibrateButtons()
        manageViews()
        initializeHideKeyboard()
    }
    
    //###################################################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //###################################################################################//
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViewLayout()
    }
    
    //############################################################################################################################//
    //#                                              View Management Functions                                                   #//
    //############################################################################################################################//
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //Function to display elements on the screen

    //###################################################################################//
    
    func configureViewLayout(){
        scrollView.frame = view.bounds
        oldPasswordTextField.frame = CGRect(x: 30, y: 60, width: view.width-60, height: 52)
        descriptionLabel.frame = CGRect(x: 30, y: oldPasswordTextField.bottom+15, width: oldPasswordTextField.width, height: oldPasswordTextField.height)
        changePasswordTextField.frame = CGRect(x: 30, y: descriptionLabel.bottom+15, width: oldPasswordTextField.width, height: oldPasswordTextField.height)
        confirmPasswordTextField.frame = CGRect(x: 30, y: changePasswordTextField.bottom+15, width: oldPasswordTextField.width, height: oldPasswordTextField.height)
        changePasswordButton.frame = CGRect(x: 30, y: confirmPasswordTextField.bottom+20, width: oldPasswordTextField.width, height: oldPasswordTextField.height)
}
    
    //###################################################################################//
    
    //Adding elements to the view

    func manageViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(oldPasswordTextField)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(changePasswordTextField)
        scrollView.addSubview(confirmPasswordTextField)
        scrollView.addSubview(changePasswordButton)
    }

    //###################################################################################//
    
    func calibrateButtons(){
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
    }
    
    //###################################################################################//
    
    func continueFunctionality(){
        oldPasswordTextField.delegate = self
        changePasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //###################################################################################//
    
    func initializeHideKeyboard(){
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(
     target: self,
     action: #selector(dismissMyKeyboard))
     view.addGestureRecognizer(tap)
     }
    
    //###################################################################################//
    
     @objc func dismissMyKeyboard(){
     view.endEditing(true)
     }

    //############################################################################################################################//
    //#                                                  Button Functions                                                        #//
    //############################################################################################################################//
    
    //Objective C code to determine what happens when login button is tapped
    
    @objc private func changePasswordButtonTapped(){
        
        let keychain = KeychainSwift()
        
        if let username = XMPPController.shared.xmppStream.myJID?.user {
            
            let keyPass = "\(username)Password"
            
            let oldPass = keychain.get(keyPass)
            
            guard let oldPassword = oldPasswordTextField.text,
                  oldPassword == oldPass! else {
                passwordIncorrect()
                return
            }
            
            guard let password = changePasswordTextField.text, let confirmedPassword = confirmPasswordTextField.text,
                  !password.isEmpty, !confirmedPassword.isEmpty, password.count >= 6 else {
                alertChangePasswordError()
                return
            }
            guard let password = changePasswordTextField.text, let confirmedPassword = confirmPasswordTextField.text,
                  password == confirmedPassword else {
                passwordNoMatchError()
                return
            }
            
            let user = XMPPController.shared.xmppStream.myJID?.user
            
            XMPPController.shared.changePassword(user: user!, host: "cipher.com", newPassword: password)
            keychain.set(password, forKey: keyPass)

            let vc = HomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            
        }
        
        
    }

    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    func alertChangePasswordError(){
        let alert = UIAlertController(title: "Whoops", message: "Please enter all information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //###################################################################################//
    
    func passwordNoMatchError() {
        let alert = UIAlertController(title: "Whoops", message: "Passwords don't match", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //###################################################################################//
    
    func passwordIncorrect() {
        let alert = UIAlertController(title: "Whoops", message: "Current password is incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
    
    //Design of the Password Text Field
    
    private let oldPasswordTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "existing password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    //###################################################################################//
    
    private let descriptionLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Password must be at least 6 characters long"
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next", size: 10)
        label.textAlignment = .center
        
        return label
        
    }()
    
    //###################################################################################//
    
    private let changePasswordTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "new password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    //###################################################################################//
    
    private let confirmPasswordTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "confirm password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    //###################################################################################//
    
    //Design of the Login Button
    
    private let changePasswordButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Add New User", for: .normal)
        button.backgroundColor = .init(red: 0, green: 0.6, blue: 0.31, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //###################################################################################//
    
 
}

//############################################################################################################################//
//#                                                     Extensions                                                           #//
//############################################################################################################################//

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == oldPasswordTextField{
            changePasswordTextField.becomeFirstResponder()
        }
        else if textField == changePasswordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField{
            changePasswordButtonTapped()
        }
        return true
    }
}

//############################################################################################################################//


