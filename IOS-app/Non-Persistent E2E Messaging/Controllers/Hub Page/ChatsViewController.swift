//
//  ChatsViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import XMPPFramework
import UIKit

class ChatsViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    var tableView = UITableView()
    
    var messages:[XMPPMessageEntity] = []
    
    var filteredMessages: [XMPPMessageEntity] = []
    
    let user = XMPPJID(string: XMPPController.shared.userJID)
    
    var timer: Timer?
    
    var count = 1
    
    //############################################################################################################################//
    //#                                                 Main Functions                                                           #//
    //############################################################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calibrateButtons()
        manageViews()
        setupNavBar()
    }
    
    //###########################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    //###########################################################//
    
    //Function to determine the layout of subviews
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        configureViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        filteredMessages.removeAll()
        messages.removeAll()
        createTableView()
        fetchMessages()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(fetchMessages), userInfo: nil, repeats: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        
            timer?.invalidate()
            timer = nil
        }
    
    //############################################################################################################################//
    //#                                             View Management Functions                                                    #//
    //############################################################################################################################//
    
    func setupNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .default
        title = "The Hub"
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Change the title color
            .font: UIFont.systemFont(ofSize: 24) // Change the font size
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    //###########################################################//
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //###########################################################//
    
    func configureViewLayout(){
        
        scrollView.frame = view.bounds
        logoutButton.frame = CGRect(x: scrollView.width/2-(scrollView.width/6)+100, y: 94, width: scrollView.width/3, height: 42)
        friendsButton.frame = CGRect(x: view.width*0.05, y: 0, width: (scrollView.width*0.45)-8, height: scrollView.width/3)
        profileButton.frame = CGRect(x: view.width*0.05, y: friendsButton.bottom+8, width: friendsButton.width, height: (scrollView.width/6)-4)
        adminControlsButton.frame = CGRect(x: friendsButton.right+16, y: 0, width: friendsButton.width, height: (scrollView.width/6)-4)
        privateMessageButton.frame = CGRect(x: friendsButton.right+16, y: adminControlsButton.bottom+8, width: friendsButton.width, height: scrollView.width/3)
        tableView.frame = CGRect(x: view.width*0.05, y: privateMessageButton.bottom+8, width:view.width*0.9, height: scrollView.height*0.6)
        //outline.frame = CGRect(x: scrollView.width*0.025, y: -8, width: scrollView.width*0.95, height: scrollView.height*0.865)
        outline.frame = CGRect(x: -10, y: -8, width: scrollView.width+20, height: scrollView.height)
    }
    
    //###########################################################//
    
    func calibrateButtons(){
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        privateMessageButton.addTarget(self, action: #selector(privateMessageTapped), for: .touchUpInside)
        friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        adminControlsButton.addTarget(self, action: #selector(adminControlsTapped), for: .touchUpInside)
    }
    
    //###########################################################//
    
    func manageViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(outline)
        scrollView.addSubview(privateMessageButton)
        scrollView.addSubview(friendsButton)
        scrollView.addSubview(profileButton)
        scrollView.addSubview(adminControlsButton)
        scrollView.addSubview(tableView)
    }
    
    func setGradientBackground(){
        //let colorTop =  UIColor(red: 48.0/255.0, green: 24.0/255.0, blue: 163.0/255.0, alpha: 1.0).cgColor
        //let colorBottom = UIColor(red: 158.0/255.0, green: 140.0/255.0, blue: 189.0/255.0, alpha: 1.0).cgColor
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    //Nonfunctional
    func confirmLogout(){
        let confirm = UIAlertController(title: "Are you sure you want to log out?", message: "You will be disconnected from the server.", preferredStyle: .actionSheet)
        confirm.addAction(UIAlertAction(title: "Yes, I want to disconnect", style: .cancel, handler: nil))
        confirm.addAction(UIAlertAction(title: "No, dont log me out", style: .destructive))
    }
    
    //###########################################################//
    
    //Fetches Messages for the messages table
    
    @objc func fetchMessages(){
        //print("Fetching Messages...")
        
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
            DispatchQueue.main.async {
                //print("Updating Table...")
                self.tableView.reloadData()
            }
        }
        catch{
            print("Error fetching messages")
        }
    }
    
    func capitalizeFirstCharacter(of input: String) -> String {
        guard !input.isEmpty else { return input }
        
        let firstCharacter = input.prefix(1).capitalized
        let remainingCharacters = input.dropFirst()
        
        return "\(firstCharacter)\(remainingCharacters)"
    }
    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    @objc private func friendsButtonTapped(){

        let vc = FriendsViewController()
        vc.title = "Your Friends"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //###########################################################//
    
    @objc private func privateMessageTapped() {
        
    
        
        let vc = PrivateMessageViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //###########################################################//
    
    @objc private func profileTapped(){
        let vc = MessagesViewController()
        vc.title = "Your Messages"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //###########################################################//
    
    @objc private func adminControlsTapped(){
        
        let vc = SettingsViewController()
        vc.title = "Controls"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //###########################################################//
    
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
    //#                                                 UI Elements                                                            #//
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
    
    //###################################################################################//
    
    private let privateMessageButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Group\nChats", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .bottom
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }()
    
    //###################################################################################//
    
    private let friendsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Friends", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .bottom
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        return button
    }()
    
    //###################################################################################//
    
    private let profileButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .bottom
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        return button
    }()
    
    //###################################################################################//
    
    private let adminControlsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .bottom
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        return button
    }()
    
    //###################################################################################//
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.backgroundColor = .white
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.register(MessagesViewCell.self, forCellReuseIdentifier: "MessagesViewCell")
    }
    
    private let outline: UILabel = {
        let outline = UILabel()
        outline.layer.borderWidth = 2
        outline.layer.borderColor = UIColor.white.cgColor
        outline.layer.cornerRadius = 20
        //outline.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 193.0/255.0, blue: 5.0/255.0, alpha: 1.0).cgColor
        outline.layer.backgroundColor = UIColor.black.cgColor
        return outline
    }()
}

//############################################################################################################################//

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredMessages.count
    }
    
    //###########################################################//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let recipient = filteredMessages[indexPath.row].recipient
        let selectedSender = filteredMessages[indexPath.row].sender
        let userMessages = messages.filter { $0.recipient == recipient }
        let messagesFromSender = userMessages.filter { $0.sender == selectedSender }
        
        let messagesVC = MessagesViewController()
        messagesVC.selectedSender = selectedSender!
        messagesVC.messagesFromSender = messagesFromSender
        filteredMessages.removeAll()
            
            navigationController?.pushViewController(messagesVC, animated: true)
        
    }
    
    //###########################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesViewCell", for: indexPath) as! MessagesViewCell
        
        let message = self.filteredMessages[indexPath.row]
        var messageCount = 0
        var capitalizedName = ""
        if let sender = message.sender {
            capitalizedName = capitalizeFirstCharacter(of: sender)
        }
        for allMessages in self.messages {
            if allMessages.sender == message.sender{
                messageCount+=1
            }
        }
        
        
        
        cell.mainTextLabel.text = capitalizedName
        if messageCount == 1 {
            cell.secondaryTextLabel.text = "1 new message"
        }
        else {
            cell.secondaryTextLabel.text = "\(messageCount) new messages"
        }
        
        
        /*
        if #available(iOS 14.0, *) {
            
            let message = self.filteredMessages[indexPath.row]
            var content = cell.defaultContentConfiguration()
            content.text = message.sender
            content.secondaryText = String("Delivered ... ago")
            cell.contentConfiguration = content
            
        }
        else{
            let message = self.filteredMessages[indexPath.row]
            cell.textLabel?.text = message.sender
            cell.detailTextLabel?.text = ""
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from your data source
            let messagesToDelete = self.filteredMessages[indexPath.row]
            self.filteredMessages.remove(at: indexPath.row)
            for message in messages {
                if message.sender == messagesToDelete.sender{
                    context.delete(message)
                    
                }
            }
            fetchMessages()
        }
    }
}
