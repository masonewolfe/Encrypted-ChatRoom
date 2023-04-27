//
//  LoginViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/1/23.
//

import Foundation
import UIKit
import XMPPFramework
import KeychainSwift


class LoginViewController: UIViewController{
    
    //############################################################################################################################//
    //#                                                 Main Functions                                                           #//
    //############################################################################################################################//
    
    //Function to display elements on the screen
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        //view.backgroundColor = .init(red: 0.65, green: 0.7, blue: 0.9, alpha: 1)
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
        loginButton.frame = CGRect (x: 30, y: passwordTextField.bottom+15, width: scrollView.width-60, height: 52)
        registerButton.frame = CGRect (x: 50, y: loginButton.bottom+15, width: scrollView.width-100, height: 44)
    }
    
    //###################################################################################//
    
    func manageViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundStripe())
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
    }
    
    //###################################################################################//
    
    func calibrateButtons(){
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    //###################################################################################//
    
    func continueFunctionality(){
        usernameTextField.delegate = self
        passwordTextField.delegate = self
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
        stripe.frame = CGRect(x: -view.width/4.25, y: view.height*0.1, width: view.width*1.5, height: view.height*0.15)
        stripe.layer.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        stripe.layer.borderWidth = 2
        stripe.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        stripe.transform = CGAffineTransform(rotationAngle: 120)
        return stripe
    }
    
    
    
    //############################################################################################################################//
    //#                                             Button Functions                                                             #//
    //############################################################################################################################//
    
    //Objective C code to determine what happens when login button is tapped
    
    @objc private func loginButtonTapped(){
        guard let username = usernameTextField.text, let password = passwordTextField.text,
              !username.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        let jid = String("\(username)@cipher.com")

        //XMPP Login
    
        XMPPController.shared.userJID = jid
        XMPPController.shared.password = password
        XMPPController.shared.connect()
        
        let seconds = 2.0
        let defaults = UserDefaults.standard
        let keychain = KeychainSwift()
        let keyPass = "\(username)Password"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            if XMPPController.shared.xmppStream.isAuthenticated {
                defaults.set(true, forKey: "logged_in")
                defaults.set(jid, forKey: "savedUserJID")
                keychain.set(password, forKey: keyPass)
                
                let vc = HomeViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            else {
                self.showAuthenticationFailedAlert()
            }
            
        }
    }
    
    //###################################################################################//
    
    private func showAuthenticationFailedAlert() {
        let alert = UIAlertController(title: "Authentication Failed", message: "The provided password is incorrect. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //###################################################################################//
    
    //Objective C code to determine what happens when register button is tapped
    
    @objc private func registerButtonTapped(){
        
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    //Function to alert for Login Error
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Whoops", message: "Please enter all information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    //############################################################################################################################//
    //#                                                 UI Elements                                                              #//
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
    
    //Design of the Login Button
    
    private let loginButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //###################################################################################//
    
    //Design of the Register Button
    
    private let registerButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .init(red: 245/255, green: 193/255, blue: 5/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
}
//############################################################################################################################//
//#                                                     Extensions                                                           #//
//############################################################################################################################//

//Extension to determine what happens when return is pressed while in text fields (e.g. Automatically move to the next text field)

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            loginButtonTapped()
        }
        return true
    }
}

//############################################################################################################################//



