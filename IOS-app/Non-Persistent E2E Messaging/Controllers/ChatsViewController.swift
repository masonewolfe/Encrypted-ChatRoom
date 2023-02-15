//
//  ViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import UIKit

class ChatsViewController: UIViewController {
    
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
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        privateMessageButton.addTarget(self, action: #selector(privateMessageTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(header)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(privateMessageButton)
    }
    
//############################################################################################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        else{
            if XMPPController.shared.xmppStream.isConnected {
                print("Logged in")
            }
            else{
                print("Automatically connecting to XMPP Server...")
                XMPPController.shared.userJID = defaults.string(forKey: "savedUserJID")!
                XMPPController.shared.password = defaults.string(forKey: "savedPassword")!
                XMPPController.shared.connect()
            }
        }
    }
    
//############################################################################################################################//
    
    //Function to determine the layout of subviews
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        
        scrollView.frame = view.bounds
        logoutButton.frame = CGRect(x: scrollView.width/2-(scrollView.width/6)+100, y: 94, width: scrollView.width/3, height: 42)
        privateMessageButton.frame = CGRect(x: 60, y: 300, width: scrollView.width-120, height: 52)
        header.frame = CGRect(x: 0, y: 0, width: 90, height: 120)
    }
    
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
    
    func confirmLogout(){
        let confirm = UIAlertController(title: "Are you sure you want to log out?", message: "You will be disconnected from the server.", preferredStyle: .actionSheet)
        confirm.addAction(UIAlertAction(title: "Yes, I want to disconnect", style: .cancel, handler: nil))
        confirm.addAction(UIAlertAction(title: "No, dont log me out", style: .destructive))
    }
    
    //############################################################################################################################//
        
        private let privateMessageButton: UIButton = {
            
            let button = UIButton()
            button.setTitle("Send Private Message", for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            return button
        }()
        
    //############################################################################################################################//
        
        @objc private func privateMessageTapped() {
            
            let vc = PrivateMessageViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    
    //############################################################################################################################//
    
    private var header: UILabel {
        
        let title = UILabel()
        title.text = String("SDIM")
        title.font = UIFont(name: "Avenir Next", size: 45)
        title.textColor = .black
        title.sizeToFit()
        title.center = CGPointMake(100, 120)

        return title
        
    }
        
}

