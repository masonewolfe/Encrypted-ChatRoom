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
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//
    
    //Function to display elements on the screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        calibrateButtons()
        continueFunctionality()
        manageViews()
        setupNavBar()
    }
    
    //###################################################################################//
    
    //Function to determine the layout of subviews
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        configureViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    
    
    
    //############################################################################################################################//
    //#                                             View Management Functions                                                    #//
    //############################################################################################################################//
    
    func setupNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    //Establish the Scroll View to allow for scrolling and zooming if necessary
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //###################################################################################//
    
    func configureViewLayout(){
        scrollView.frame = view.bounds
        usernameTextField.frame = CGRect (x: 30, y: 20, width: scrollView.width-60, height: 52)
        passwordTextField.frame = CGRect (x: 30, y: usernameTextField.bottom+15, width: scrollView.width-60, height: 52)
        confirmPasswordTextField.frame = CGRect (x: 30, y: passwordTextField.bottom+15, width: scrollView.width-60, height: 52)
        registerButton.frame = CGRect (x: 30, y: confirmPasswordTextField.bottom+15, width: scrollView.width-60, height: 52)
    }
    
    //###################################################################################//
    
    //Adding elements to the view

    func manageViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundStripe())
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(confirmPasswordTextField)
        scrollView.addSubview(registerButton)
    }
    
    //###################################################################################//
    
    func continueFunctionality(){
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //###################################################################################//
    
    func calibrateButtons(){
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    //###################################################################################//
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func backgroundStripe() -> UIView {
        
        let stripe = UIView()
        stripe.frame = CGRect(x: -view.width/4.25, y: view.height/3.5, width: view.width*1.5, height: view.height*0.15)
        stripe.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 193.0/255.0, blue: 5.0/255.0, alpha: 1.0).cgColor
        stripe.layer.borderWidth = 2
        stripe.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        stripe.transform = CGAffineTransform(rotationAngle: 120)
        return stripe
    }

    //############################################################################################################################//
    //#                                                  Button Functions                                                        #//
    //############################################################################################################################//
    
    //Objective C code to determine what happens when login button is tapped
    
    @objc private func registerButtonTapped(){
        guard var username = usernameTextField.text, var password = passwordTextField.text, let confirmedPass = confirmPasswordTextField.text,
              !username.isEmpty, !password.isEmpty, !confirmedPass.isEmpty else {
            alertUserRegistrationError()
            return
        }
        guard var password = passwordTextField.text, let confirmedPass = confirmPasswordTextField.text,
              password == confirmedPass else {
            passwordsNoMatch()
            return
        }
        guard var password = passwordTextField.text, let confirmedPass = confirmPasswordTextField.text,
              password == confirmedPass, password.count >= 6 else {
              passwordTooShort()
              return
          }
        
        username = username.lowercased()
        XMPPController.shared.registerUser(user: username, host: "cipher.com", password: password)
        password = ""
        
        let mainVC = LoginViewController() // Replace with your main view controller class
        let navigationController = UINavigationController(rootViewController: mainVC)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    //Function to alert for Registration Error
    
    func alertUserRegistrationError(){
        let alert = UIAlertController(title: "Oopsie", message: "All fields must be filled in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func passwordsNoMatch(){
        let alert = UIAlertController(title: "Oopsie", message: "Passwords do not match", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func passwordTooShort(){
        let alert = UIAlertController(title: "Oopsie", message: "Password must be at least 6 characters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
        
        //Design of the Email Text Field
        
        private let usernameTextField: UITextField = {
            
            let textField = UITextField()
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.returnKeyType = .continue
            textField.layer.cornerRadius = 12
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            textField.placeholder = "johnappleseed"
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            textField.leftViewMode = .always
            textField.backgroundColor = .white
            return textField
        }()
        
    //###################################################################################//
        
        //Design of the Password Text Field
        
        private let passwordTextField: UITextField = {
            
            let textField = UITextField()
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.returnKeyType = .continue
            textField.layer.cornerRadius = 12
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            textField.placeholder = "password"
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            textField.leftViewMode = .always
            textField.backgroundColor = .white
            textField.isSecureTextEntry = true
            return textField
        }()
    
    //###################################################################################//
        
        //Design of the Password Text Field
        
        private let confirmPasswordTextField: UITextField = {
            
            let textField = UITextField()
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.returnKeyType = .continue
            textField.layer.cornerRadius = 12
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            textField.placeholder = "confirm password"
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            textField.leftViewMode = .always
            textField.backgroundColor = .white
            textField.isSecureTextEntry = true
            return textField
        }()
        
    //###################################################################################//
        
        //Design of the Register Button
        
        private let registerButton: UIButton = {
            
            let button = UIButton()
            button.setTitle("Register", for: .normal)
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            return button
        }()
        
}

//############################################################################################################################//
//#                                                     Extensions                                                           #//
//############################################################################################################################//

//Extension to determine what happens when return is pressed while in text fields (e.g. Automatically move to the next text field)

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            registerButtonTapped()
        }
        return true
    }
}

//############################################################################################################################//

