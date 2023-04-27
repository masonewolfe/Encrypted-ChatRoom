//
//  FriendsViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/7/23.
//

import Foundation
import UIKit
import SwiftUI
import XMPPFramework
import FontAwesome_swift

class FriendsViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                               Utilities and References                                                   #//
    //############################################################################################################################//
    
    let defaults = UserDefaults.standard
    var tableView = UITableView()
    var friends = [XMPPJID]()
    let newContact = FriendCell()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var messages:[XMPPMessageEntity] = []
    
    var filteredMessages: [XMPPMessageEntity] = []
    
    let user = XMPPJID(string: XMPPController.shared.userJID)
    
    var timer: Timer?
    
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchContacts()
        manageViews()
        calibrateButtons()
        setupNavBar()
    }
    
    //###########################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //###########################################################//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
        createTableView()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(updateFriendsStatus), userInfo: nil, repeats: true)
    }
    
    //###########################################################//
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    //###########################################################//
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
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
    
    //###########################################################//

    func configureViewLayout() {
        let safeArea = view.safeAreaInsets
        let buttonWidth = view.width / 5
        let buttonHeight = buttonWidth
        let bottomMargin: CGFloat = 10

        scrollView.frame = view.bounds
        scrollView.contentInset.bottom = buttonHeight + bottomMargin * 2

        friendsButton.frame = CGRect(x: buttonWidth-(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        privateMessageButton.frame = CGRect(x: friendsButton.right+(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        profileButton.frame = CGRect(x: privateMessageButton.right+(buttonWidth/4), y: view.height - (buttonHeight*2) - bottomMargin - safeArea.bottom, width: buttonWidth, height: buttonHeight)
        
       
        let buttonsHeight = buttonHeight + bottomMargin + safeArea.bottom
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - buttonsHeight - safeArea.top)
    }
    
    //###########################################################//
    
    func manageViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(privateMessageButton)
        scrollView.addSubview(friendsButton)
        scrollView.addSubview(profileButton)
        scrollView.addSubview(tableView)
    }
    
    //###########################################################//
    
    func setupNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        title = "Friends"
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Change the title color
            .font: UIFont.systemFont(ofSize: 24) // Change the font size
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let menuImage = UIImage(systemName: "line.horizontal.3")
        let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(hamburgerMenuTapped))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //###########################################################//
    
    func calibrateButtons(){

        privateMessageButton.addTarget(self, action: #selector(privateMessageTapped), for: .touchUpInside)
        friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)

    }
    
    //###########################################################//
    
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
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    struct Cells{
        static let friendCell = "Contact"
    }
    
    //###################################################################################//
    
    
    @objc func updateFriendsStatus() {
        fetchContacts()
        self.tableView.reloadData()
    }
    //###################################################################################//
    
    //Will retrieve current subscriptions
    /*
    func fetchContacts() {
        friends = XMPPController.shared.xmppRosterStorage.jids(for: XMPPController.shared.xmppStream)
        
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        
        for (index, friend) in friends {
            do {
                let fetchedRequests = try context.fetch(fetchRequest)
                for req in fetchedRequests {
                    if req.username == friend.user {
                        if req.friends == false {
                            friends.remove(at: index)
                        }
                    }
                }
            } catch {
                print("\n--Error fetching friend requests--\n")
            }
        }
    }*/
    
    func fetchContacts() {
        friends = XMPPController.shared.xmppRosterStorage.jids(for: XMPPController.shared.xmppStream)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        
        var filteredFriends: [XMPPJID] = []
        
        for friend in friends {
            fetchRequest.predicate = NSPredicate(format: "username == %@", friend.user!)
            do {
                let fetchedRequests = try context.fetch(fetchRequest)
                if let fetchedRequest = fetchedRequests.first {
                    if fetchedRequest.friends == true {
                        // Add this friend to the filteredFriends array
                        filteredFriends.append(friend)
                    }
                }
            } catch {
                print("Error fetching friend")
            }
        }
        
        friends = filteredFriends
    }


    
    //###################################################################################//
    
    @objc func fetchMessages(){
        print("Fetching Messages...")
        
        do{
            self.messages = try context.fetch(XMPPMessageEntity.fetchRequest())
            
            
            for message in messages {
                if user?.user == message.recipient {
                    var senderExists = false
                    for senders in filteredMessages {
                        if message.sender == senders.sender {
                            senderExists = true
                            break
                        }
                    }
                    if !senderExists {
                        filteredMessages.append(message)
                    }
                }
            }
        }
        catch{
            print("Error fetching messages")
        }
    }
    
    //###################################################################################//
    
    func presentAddFriendViewController() {
        let addFriendVC = AddFriendViewController()
        addFriendVC.modalPresentationStyle = .overFullScreen
        addFriendVC.view.alpha = 0
        
        present(addFriendVC, animated: false, completion: {
            UIView.animate(withDuration: 0.3, animations: {
                addFriendVC.view.alpha = 1
            })
        })
    }
    
    //###########################################################//
    
    func presentFriendRequestsViewController() {
        let addFriendVC = FriendRequestsViewController()
        addFriendVC.modalPresentationStyle = .overFullScreen
        addFriendVC.view.alpha = 0
        
        present(addFriendVC, animated: true, completion: {
            UIView.animate(withDuration: 0.3, animations: {
                addFriendVC.view.alpha = 1
            })
        })
    }

    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    @objc private func friendsButtonTapped(){
        let viewControllerToPresent = FriendsViewController()
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
        return
    }
    
    //###########################################################//
    
    @objc private func privateMessageTapped() {
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
    
    @objc func rightBarButtonTapped() {
        print("Right bar button tapped")
        presentAddFriendViewController()
    }
    
    //###########################################################//
    
    @objc func hamburgerMenuTapped() {
        presentFriendRequestsViewController()
    }
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
    
    //Creates the table view
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.clipsToBounds = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.register(FriendCell.self, forCellReuseIdentifier: Cells.friendCell)
    }
    
    //###################################################################################//
    
    private let privateMessageButton: UIButton = {
        
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
        button.layer.borderWidth = 5
        button.layer.borderColor = .init(red: 42/255, green: 204/255, blue: 37/255, alpha: 1.0)
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
        button.layer.borderWidth = 3
        button.layer.borderColor = .init(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.4)
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }()
    
}

//############################################################################################################################//
//#                                                    Extensions                                                            #//
//############################################################################################################################//

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    //###########################################################//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let selectedFriend = friends[indexPath.row]
        fetchMessages()

        let messagesVC = MessagesViewController()
        messagesVC.selectedSender = selectedFriend.user!
        messagesVC.messagesFromSender = filteredMessages
        filteredMessages.removeAll()
            
            navigationController?.pushViewController(messagesVC, animated: true)
        
    }
    
    
    //###########################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.friendCell) as? FriendCell
        let currentContact = friends[indexPath.row]
        let status = defaults.string(forKey: currentContact.bare)
        
        cell!.name.text = currentContact.user?.capitalized
        
        cell!.name.text = currentContact.user?.capitalized
        if status == "online"{
            cell?.onlineIndicator.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell?.onlineIndicator.text = String.fontAwesomeIcon(name: .signal)
            cell?.onlineIndicator.textColor = UIColor.green
        }
        if status == "offline"{
            cell?.onlineIndicator.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell?.onlineIndicator.text = String.fontAwesomeIcon(name: .signal)
            cell?.onlineIndicator.textColor = UIColor.red
        }
        return cell!
    }
}

//############################################################################################################################//

