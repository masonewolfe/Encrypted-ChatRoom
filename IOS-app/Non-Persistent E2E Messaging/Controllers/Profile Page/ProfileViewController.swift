//
//  ProfileViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/27/23.
//

import Foundation
import SwiftUI
import UIKit
import XMPPFramework

class ProfileViewController: UIViewController{
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    //Allows access to default values
    let defaults = UserDefaults.standard
    
    var tableView = UITableView()
    
    var contentView = UIView()
    
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calibrateButtons()
        manageViews()
        setupNavBar()
    }
    
    //###################################################################################//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
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
    
    //###################################################################################//
    
    func setupNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        title = "Profile"
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Change the title color
            .font: UIFont.systemFont(ofSize: 24) // Change the font size
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    //###################################################################################//
    
    func configureViewLayout() {
        let safeArea = view.safeAreaInsets
        let buttonWidth = view.width / 5
        let buttonHeight = buttonWidth
        let bottomMargin: CGFloat = 10
        
        scrollView.frame = view.bounds
        scrollView.contentInset.bottom = buttonHeight + bottomMargin * 2
        
        friendsButton.frame = CGRect(x: buttonWidth-(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        homeButton.frame = CGRect(x: friendsButton.right+(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        profileButton.frame = CGRect(x: homeButton.right+(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        
        let buttonsHeight = buttonHeight + bottomMargin + safeArea.bottom
        
        profileCard.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - buttonsHeight - safeArea.top)
        
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIcon.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 20),
            userIcon.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20),
            userIcon.widthAnchor.constraint(equalToConstant: 100),
            userIcon.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        displayName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayName.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 40),
            displayName.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor, constant: 20)
        ])
        
        presenceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            presenceLabel.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 10),
            presenceLabel.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor, constant: 20)
        ])
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: userIcon.bottomAnchor, constant: 20),
            separatorLine.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -20),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleSwitch.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20),
            toggleSwitch.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: 0)
        ])
        
        toggleSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleSwitchLabel.centerYAnchor.constraint(equalTo: toggleSwitch.centerYAnchor),
            toggleSwitchLabel.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20)
        ])
        
        messagesSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messagesSwitch.topAnchor.constraint(equalTo: toggleSwitch.bottomAnchor, constant: 20),
            messagesSwitch.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: 0)
        ])
        
        messagesSwitchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messagesSwitchLabel.centerYAnchor.constraint(equalTo: messagesSwitch.centerYAnchor),
            //toggleSwitchLabel.leadingAnchor.constraint(equalTo: toggleSwitch.trailingAnchor, constant: 10)
            messagesSwitchLabel.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20)
        ])
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.backgroundColor = .init(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1.0)
        settingsButton.layer.cornerRadius = 12
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: messagesSwitch.bottomAnchor, constant: 20),
            settingsButton.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -20),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //###################################################################################//
    
    //Adding elements to the view

    func manageViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(homeButton)
        scrollView.addSubview(friendsButton)
        scrollView.addSubview(profileButton)
        scrollView.addSubview(contentView)
        
        scrollView.addSubview(profileCard)
        
        profileCard.addSubview(userIcon)
        profileCard.addSubview(displayName)
        profileCard.addSubview(presenceLabel)
        profileCard.addSubview(separatorLine)
        profileCard.addSubview(toggleSwitchLabel)
        profileCard.addSubview(toggleSwitch)
        profileCard.addSubview(messagesSwitchLabel)
        profileCard.addSubview(messagesSwitch)
        profileCard.addSubview(settingsButton)
    }

    //###################################################################################//
    
    func calibrateButtons(){
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
    }
    
    //###################################################################################//
    
    func setGradientBackground(){
        //let colorTop =  UIColor(red: 48.0/255.0, green: 24.0/255.0, blue: 163.0/255.0, alpha: 1.0).cgColor
        //let colorBottom = UIColor(red: 158.0/255.0, green: 140.0/255.0, blue: 189.0/255.0, alpha: 1.0).cgColor
        let colorTop =  UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    //############################################################################################################################//
    //#                                                  Button Functions                                                        #//
    //############################################################################################################################//
    
    @objc private func friendsButtonTapped(){
        let viewControllerToPresent = FriendsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        return
    }
    
    //###########################################################//
    
    @objc private func homeTapped() {
        let viewControllerToPresent = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
    }
    
    //###########################################################//
    
    @objc private func profileTapped(){
        let viewControllerToPresent = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        return
    }
    
    //###########################################################//
    
    @objc private func settingsTapped(){
        
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //###########################################################//
    
    @objc func toggleValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            XMPPController.shared.myPresence = true
            defaults.set(true, forKey: "savedPresence")
            let presence = XMPPPresence(type: "available")
            XMPPController.shared.xmppStream.send(presence)
            profileCard.layer.borderColor = .init(red: 42/255, green: 204/255, blue: 37/255, alpha: 1.0)
            presenceLabel.text = "Appearing Online"
        } else {
            XMPPController.shared.myPresence = false
            defaults.set(false, forKey: "savedPresence")
            let presence = XMPPPresence(type: "unavailable")
            XMPPController.shared.xmppStream.send(presence)
            profileCard.layer.borderColor = UIColor.red.cgColor
            presenceLabel.text = "Appearing Offline"
        }
    }

    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
   
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
   
    private let displayName: UILabel = {
        let name = UILabel()
        if let username = XMPPController.shared.xmppStream.myJID?.user?.capitalized {
            name.text = username
        }
        name.font = UIFont(name: "Avenir Next", size: 22)
        name.textColor = .black
        return name
    }()
    
    //###################################################################################//
    
    private let presenceLabel: UILabel = {
        
        let label = UILabel()
     
        label.font = UIFont(name: "Avenir Next", size: 16)
        if XMPPController.shared.myPresence == true {
            label.text = "Appearing Online"
        }
        else {
            label.text = "Appearing Offline"
        }
        label.textColor = .black
        
        return label
    }()
    
    //###################################################################################//
    
    let toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .black
        toggle.isOn = XMPPController.shared.myPresence
        return toggle
    }()
    
    //###################################################################################//
    
    private let homeButton: UIButton = {
        
        let button = UIButton()
    
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .comment), for: .normal)
        button.backgroundColor = .init(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.4)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = .init(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    //###################################################################################//
    
    private let friendsButton: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .users), for: .normal)
        button.backgroundColor = .init(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.4)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = .init(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    //###################################################################################//
    
    private let profileButton: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .user), for: .normal)
        button.backgroundColor = .init(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.4)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 5
        button.layer.borderColor = .init(red: 42/255, green: 204/255, blue: 37/255, alpha: 1.0)
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    //###################################################################################//
    
    private let settingsButton: UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        button.backgroundColor = .init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
    private let userIcon: UILabel = {
         let iconLabel = UILabel()
         iconLabel.font = UIFont.fontAwesome(ofSize: 100, style: .solid)
         iconLabel.text = String.fontAwesomeIcon(name: .user)
         iconLabel.textColor = .systemGray
         return iconLabel
     }()
    
    private let separatorLine: UIView = {
          let line = UIView()
          line.backgroundColor = .systemGray
          return line
      }()
      
      private let toggleSwitchLabel: UILabel = {
          let label = UILabel()
          label.text = "Toggle Online Appearance"
          label.font = UIFont(name: "Avenir Next", size: 18)
          label.textColor = .black
          return label
      }()
    
    private let messagesSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Disappearing Messages"
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.textColor = .black
        return label
    }()
    
    let messagesSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .black
        //toggle.isOn = XMPPController.shared.myPresence
        return toggle
    }()
      
    
    //###################################################################################//
    
    private let profileCard: UIView = {
        
        let card = UIView()
        
        card.backgroundColor = .white
        card.layer.borderWidth = 2.5
        if XMPPController.shared.myPresence == true {
            card.layer.borderColor = .init(red: 42/255, green: 204/255, blue: 37/255, alpha: 1.0)
        }
        else {
            card.layer.borderColor = UIColor.red.cgColor
        }
        
        return card
        
    }()

}

//############################################################################################################################//
//#                                                     Extensions                                                           #//
//############################################################################################################################//

//############################################################################################################################//
