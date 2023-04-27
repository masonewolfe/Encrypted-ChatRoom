//
//  PrivateMessageViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/4/23.
//

import Foundation
import UIKit
import SwiftUI
import XMPPFramework

class PrivateMessageViewController: UIViewController{
    
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//
    
    //Used to access default values
    let defaults = UserDefaults.standard
    
    //###########################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Private Message"
        initializeHideKeyboard()
        continueFunctionality()
        calibrateButtons()
        manageView()
    }

    //###########################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //###########################################################//
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        configureViewLayout()
    }
    
    //############################################################################################################################//
    //#                                              View Management Functions                                                   #//
    //############################################################################################################################//
    
    //Allows for a scrollable view
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //###########################################################//
    
    //Determines the position of elements on the screen/view
    func configureViewLayout(){
        scrollView.frame = view.bounds
        recipientTextField.frame = CGRect(x: scrollView.left+30, y: 70, width: scrollView.width-60, height: 52)
        messageTextView.frame = CGRect(x: scrollView.left+30, y: 130, width: scrollView.width-60, height: 200)
        logoutButton.frame = CGRect(x: scrollView.width/2-(scrollView.width/6), y: recipientTextField.bottom+500, width: scrollView.width/3, height: 52)
        sendButton.frame = CGRect(x: messageTextView.left+30, y: messageTextView.bottom+30, width: messageTextView.width-60, height: 52)
        selfDestructButton.frame = CGRect(x: messageTextView.left+30, y: sendButton.bottom+30, width: messageTextView.width-60, height: 52)
    }
    
    //###########################################################//
    
    //Adds elements to the users view
    func manageView(){
        view.addSubview(scrollView)
        scrollView.addSubview(recipientTextField)
        scrollView.addSubview(messageTextView)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(sendButton)
        scrollView.addSubview(selfDestructButton)
    }
    
    //###########################################################//
    
    //Runs the referenced functions when a button is tapped
    func calibrateButtons(){
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        selfDestructButton.addTarget(self, action: #selector(selfDestructButtonTapped), for: .touchUpInside)
    }
    
    //###########################################################//
    
    func continueFunctionality(){
        recipientTextField.delegate = self
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    //Alerts if a message is filled in incorrectly
    
    func alertMsgSendError(){
        let alert = UIAlertController(title: "Whoops!", message: "Please enter all information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
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
    
    //Returns user to Chat ViewController when self destruct button is tapped
    
    @objc private func selfDestructButtonTapped() {
        
        //Loads the Chat ViewController
        
        let vc = ChatsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //###################################################################################//
    
    //Sends a message to the input recipient and returns to the Chat ViewController when the send button is tapped
    @objc private func sendButtonTapped() {
        
        //Ensures all fields are filled in and saves their values otherwise alerts an error
        
        guard let recipient = recipientTextField.text, let message = messageTextView.text,
              !recipient.isEmpty, !message.isEmpty else {
            alertMsgSendError()
            return
        }
        
        //XMPP referenced from singleton class XMPPController to send the message
        let jidString = "\(recipient)@cipher.com"
        XMPPController.shared.sendMessage(message: message, recipient: jidString)
        
        //Loads Chat ViewController
        
        let vc = ChatsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //###################################################################################//
    
    //Sends user to the login screen and logs them out when log out button is tapped
    
    @objc private func logoutButtonTapped() {
        
        //resets all the deafult values for userJID and password to nil
        
        defaults.set(nil, forKey: "savedUserJID")
        defaults.set(nil, forKey: "savedPassword")
        
        //turns the flag for being "logged in" off
        
        defaults.set(false, forKey: "logged_in")
        
        XMPPController.shared.disconnectStream()
        
        //Loads the Login ViewController
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
    
    //Creates the element recipientTextField as a UI element to be used on the view
    
    private let recipientTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = " To: username"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
        
    }()
    
    //###################################################################################//
    
    //Creates the element message TextField as a UI element to be used on the view
    
    private let messageTextView: UITextView = {
        
        let textField = UITextView()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        return textField
        
    }()
    
    //###################################################################################//
    
    //Creates the element loginButton as a UI element to be used on the view
    
    private let logoutButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //###################################################################################//
    
    //Creates the element sendButton as a UI element to be used on the view
    
    private let sendButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Send Message", for: .normal)
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
    
    //Creates the element selfDestructButton as a UI element to be used on the view
    
    private let selfDestructButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
   /*
    func httpReq(){
        let url = URL(string: "http://52.188.65.46:5000")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "cipher.com"
        let body = ["username" : "mason"]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "GET"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print(error)
            } else if let data = data {
                print(data)
            } else {
                print("unexpected error")
            }
        }
        task.resume()
        
    }
    */
}

//############################################################################################################################//
//#                                                    Extensions                                                            #//
//############################################################################################################################//

extension PrivateMessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == recipientTextField{
            messageTextView.becomeFirstResponder()
        }
        return true
    }
}
    
//############################################################################################################################//
    

    

