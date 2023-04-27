//
//  LoadingScreenViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/17/23.
//

import Foundation
import UIKit
import LocalAuthentication
import KeychainSwift
import XMPPFramework
/*
class LoadingScreenViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if defaults.bool(forKey: "logged_in") {
            authenticateUser()
        }
        else {
            login()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We use Face ID to authenticate your identity for a secure login experience.") { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.login()
                    } else {
                        // Show an alert to the user if Face ID authentication fails
                        let alertController = UIAlertController(title: "Authentication Failed", message: "Face ID authentication failed. Please restart the app and try again.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Your device does not support Face ID.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    func login() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let mainVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if XMPPController.shared.xmppStream.isAuthenticated {
                    print("Already Connected")
                } else {
                    print("Automatically connecting to XMPP Server...")
                    XMPPController.shared.userJID = self.defaults.string(forKey: "savedUserJID")!
                    XMPPController.shared.password = self.defaults.string(forKey: "savedPassword")!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        XMPPController.shared.connect()
                    }
                }
            }
            startCheckConnectionTimer()
        }
    }
    
    func startCheckConnectionTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    /*@objc func checkConnection() {
        if XMPPController.shared.xmppStream.isAuthenticated {
            let mainVC = HomeViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }*/
    @objc func checkConnection() {
        if XMPPController.shared.xmppStream.isAuthenticated {
            let mainVC = HomeViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let window = UIApplication.shared.windows.first
                
                // Configure the initial state of the new view controller
                navigationController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                navigationController.view.alpha = 0
                
                // Add the new view controller to the window
                window?.addSubview(navigationController.view)
                
                // Create a zoom out animation
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
                    navigationController.view.transform = CGAffineTransform.identity
                    navigationController.view.alpha = 1
                }, completion: { _ in
                    // Update the root view controller after the animation is completed
                    window?.rootViewController = navigationController
                    window?.makeKeyAndVisible()
                })
            }
        }
    }
}

*/

class LoadingScreenViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var timer: Timer?
    
    //###################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        login()
    }
    
    //###################################################################################//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    //###################################################################################//
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
 
            timer?.invalidate()
            timer = nil
        }
    
    //###################################################################################//
    
    func login(){
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")

        
        if !isLoggedIn {
            
            
            let mainVC = LoginViewController() // Replace with your main view controller class
            let navigationController = UINavigationController(rootViewController: mainVC)
            
            // Set the navigation controller as the root view controller after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if XMPPController.shared.xmppStream.isAuthenticated {
                    print("Already Connected")
                }
                else {
                    print("Automatically connecting to XMPP Server...")
                    
                    let keychain = KeychainSwift()
                    
                    XMPPController.shared.userJID = self.defaults.string(forKey: "savedUserJID")!
                    
                    if let username = XMPPJID(string: XMPPController.shared.userJID)?.user{
                        let keyPass = "\(username)Password"
                        if let retrievedPassword = keychain.get(keyPass) {
                            print("Retrieved password: \(retrievedPassword)")
                            XMPPController.shared.password = retrievedPassword
                        }
                        else{
                            print("--Error retrieving password--\n\nLoadingScreenViewController: login()")
                        }
                    }
                    else {
                        print("--Error retrieving username--\n\nLoadingScreenViewController: login()")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        XMPPController.shared.connect()
                    }
                }
            }
        }
    }
    
    //###################################################################################//
    
    @objc func checkConnection() {
        if XMPPController.shared.xmppStream.isAuthenticated {
            
            let mainVC = HomeViewController() // Replace with your main view controller class
            let navigationController = UINavigationController(rootViewController: mainVC)

            // Set the navigation controller as the root view controller after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            
        }
       
    }
}
