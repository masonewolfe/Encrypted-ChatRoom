//
//  AddFriendViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 4/18/23.
//

import UIKit
import XMPPFramework

class AddFriendViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        modalPresentationStyle = .overFullScreen
        setupBlurEffect()
        initializeHideKeyboard()
        manageViews()
        calibrateButtons()
    }
    
    //############################################################################################################################//
    //#                                              View Management Functions                                                   #//
    //############################################################################################################################//
    
    func manageViews() {
        view.addSubview(usernameTextField)
        view.addSubview(dismissButton)
        view.addSubview(sendRequestButton)
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        sendRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            usernameTextField.widthAnchor.constraint(equalToConstant: 200),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendRequestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendRequestButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            sendRequestButton.widthAnchor.constraint(equalToConstant: 180),
            sendRequestButton.heightAnchor.constraint(equalToConstant: 40),
            
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
            dismissButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //###########################################################//
    
    func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark) // You can choose the blur style you prefer (.light, .extraLight, .dark, .regular, .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0) // Add the blurEffectView as the first subview, so it's below other views
    }

    
    //###########################################################//
    
    func calibrateButtons() {
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        sendRequestButton.addTarget(self, action: #selector(sendRequestTapped), for: .touchUpInside)
        
    }
    
    //###########################################################//
    
    func initializeHideKeyboard(){
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(
     target: self,
     action: #selector(dismissMyKeyboard))
     view.addGestureRecognizer(tap)
     }
    
    //###########################################################//
    
     @objc func dismissMyKeyboard(){
     view.endEditing(true)
     }
    
    //###########################################################//
    
    func dismissAddFriendViewController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    //###########################################################//
    
    func alertSendError(){
        let alert = UIAlertController(title: "Whoops!", message: "Please enter a username", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    @objc func dismissButtonTapped() {
            dismissAddFriendViewController()
        }
    
    //###########################################################//
    
    @objc func sendRequestTapped() {
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            alertSendError()
            return
        }
        
        let jid = XMPPJID(string: "\(username)@cipher.com")!
        XMPPController.shared.sendSubscriptionRequest(to: jid, xmppStream: XMPPController.shared.xmppStream)
        print("Friend request sent to \(username)")
        dismissAddFriendViewController()
    }
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
    
    private let usernameTextField: UITextField = {
        
        let text = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0),
            .font: UIFont(name: "Avenir Next", size: 16)!
        ]
        text.attributedPlaceholder = NSAttributedString(
            string: "username",
            attributes: attributes
        )
        text.textColor = .white
        text.layer.borderWidth = 3
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.layer.cornerRadius = 12
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        text.leftViewMode = .always
        return text
        
    }()
    
    //###########################################################//
    
    private let sendRequestButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Send Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 20)
        button.backgroundColor = .black
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 12

        return button
        
    }()
    
    //###########################################################//
    
    private let dismissButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.init(red: 100, green: 100, blue: 100, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return button
    }()
    
    
    

}
