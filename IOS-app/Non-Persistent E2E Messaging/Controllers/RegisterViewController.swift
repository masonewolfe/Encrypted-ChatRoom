//
//  RegisterViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/2/23.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
//############################################################################################################################//
    
    //Establish the Scroll View to allow for scrolling and zooming if necessary
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
        
    }()
    
//############################################################################################################################//
    
    //Design of the Email Text Field
    
    private let emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "johnappleseed@selfdestructim.com"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
//############################################################################################################################//
    
    //Design of the Password Text Field
    
    private let passwordTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
//############################################################################################################################//
    
    //Design of the Register Button
    
    private let registerButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
//############################################################################################################################//
    
    //Function to display elements on the screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .init(red: 0.65, green: 0.7, blue: 0.9, alpha: 1)
        
        //Calls registerButtonTapped() when it is tapped
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Adding elements to the view
        view.addSubview(scrollView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
    }
    
//############################################################################################################################//
    
    //Function to determine the layout of subviews
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        scrollView.frame = view.bounds
        
        emailTextField.frame = CGRect (x: 30, y: 20, width: scrollView.width-60,
                                       height: 52)
        passwordTextField.frame = CGRect (x: 30, y: emailTextField.bottom+15, width: scrollView.width-60,
                                          height: 52)
        registerButton.frame = CGRect (x: 30, y: passwordTextField.bottom+15, width: scrollView.width-60,
                                    height: 52)
    }
//############################################################################################################################//
    
    //Objective C code to determine what happens when login button is tapped
    
    @objc private func registerButtonTapped(){
        guard let email = emailTextField.text, let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserRegistrationError()
            return
        }
    }
    
//############################################################################################################################//
    
    //Function to alert for Registration Error
    
    func alertUserRegistrationError(){
        let alert = UIAlertController(title: "Oopsie", message: "Please enter all information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

//############################################################################################################################//

//Extension to determine what happens when return is pressed while in text fields (e.g. Automatically move to the next text field)

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            registerButtonTapped()
        }
        return true
    }
}



