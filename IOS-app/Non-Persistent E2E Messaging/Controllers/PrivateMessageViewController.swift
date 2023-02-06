//
//  CustomChatViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/4/23.
//

import Foundation
import UIKit
import SwiftUI
import XMPPFramework

class PrivateMessageViewController: UIViewController {
    
    //############################################################################################################################//
    
    let defaults = UserDefaults.standard
    
    //############################################################################################################################//
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
        
    }()
    
    //############################################################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        title = "Private Message"
        
        //recieverTextField.delegate = self
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        selfDestructButton.addTarget(self, action: #selector(selfDestructButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(recipientTextField)
        scrollView.addSubview(messageTextView)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(sendButton)
        scrollView.addSubview(selfDestructButton)
    }
    
    //############################################################################################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //############################################################################################################################//
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        scrollView.frame = view.bounds
        recipientTextField.frame = CGRect(x: scrollView.left+30, y: 70, width: scrollView.width-60, height: 52)
        messageTextView.frame = CGRect(x: scrollView.left+30, y: 130, width: scrollView.width-60, height: 200)
        logoutButton.frame = CGRect(x: scrollView.width/2-(scrollView.width/6), y: recipientTextField.bottom+500, width: scrollView.width/3, height: 52)
        sendButton.frame = CGRect(x: messageTextView.left+30, y: messageTextView.bottom+30, width: messageTextView.width-60, height: 52)
        selfDestructButton.frame = CGRect(x: messageTextView.left+30, y: sendButton.bottom+30, width: messageTextView.width-60, height: 52)
    }
    
    //############################################################################################################################//
    
    @objc private func logoutButtonTapped() {
        
        defaults.set(nil, forKey: "savedUserJID")
        defaults.set(nil, forKey: "savedPassword")
        defaults.set(false, forKey: "logged_in")
        XMPPController.shared.disconnectStream()
        
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //############################################################################################################################//
    
    @objc private func sendButtonTapped() {
        guard let recipient = recipientTextField.text, let message = messageTextView.text,
              !recipient.isEmpty, !message.isEmpty else {
            alertMsgSendError()
            return
        }
        XMPPController.shared.sendMessage(message: message, recipient: recipient)
        let vc = ChatsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //############################################################################################################################//
    
    func alertMsgSendError(){
        let alert = UIAlertController(title: "Whoops!", message: "Please enter all information correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //############################################################################################################################//
    
    @objc private func selfDestructButtonTapped() {
        
        let vc = ChatsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //############################################################################################################################//
    
    private let recipientTextField: UITextField = {
        
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = " To: xxx@selfdestructim.com"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
        
    }()
    
    //############################################################################################################################//
    
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
    
    //############################################################################################################################//
    
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
    
    //############################################################################################################################//
    
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
    
    //############################################################################################################################//
    
    private let selfDestructButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Self Destruct", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
//############################################################################################################################//
    
}

//############################################################################################################################//


/**
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            loginButtonTapped()
        }
        return true
    }
}
    */
    

    

