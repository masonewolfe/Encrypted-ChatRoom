//
//  AdminPrototypeVC.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/8/23.
//

import UIKit
import XMPPFramework

class SettingsViewController: UITableViewController {
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    //Used to access default values
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //############################################################################################################################//
    //#                                                  Main Functions                                                          #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Register a UITableViewCell class for your TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    //############################################################################################################################//
    //#                                            View Management Fucntions                                                     #//
    //############################################################################################################################//
    
    // Define your settings menu structure
    let settingsMenu: [[String: Any]] = [
        ["title": "Change Password", "action": #selector(changePasswordTapped)],
        ["title": "Clear All Friends", "action": #selector(clearFriendsTapped)],
        ["title": "Clear All Messages", "action": #selector(clearAllMessagesTapped)],
        ["title": "Log Out", "action": #selector(logoutTapped)],
    ]
    
    //###########################################################//
    
    // Implement UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenu.count
    }
    
    //###########################################################//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        let settingItem = settingsMenu[indexPath.row]
        cell.textLabel?.text = settingItem["title"] as? String
        
        return cell
    }
    
    //###########################################################//
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let settingItem = settingsMenu[indexPath.row]
        if let selector = settingItem["action"] as? Selector {
            perform(selector)
        }
    }
    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    // Your existing button action methods
    @objc private func changePasswordTapped() {
        let vc = ChangePasswordViewController()
        vc.title = "Change Password"
        navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //###########################################################//
    
    @objc private func clearFriendsTapped() {
        let alertController = UIAlertController(title: "Clear friends", message: "Do you want to clear all friends and friend requests?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.clearFriendsRequestsFromCoreData()
            self.removeFriendsFromXMPP()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    //###########################################################//
    
    func clearFriendsRequestsFromCoreData() {
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        
        do {
            let fetchedFriendRequests = try context.fetch(fetchRequest)
            for request in fetchedFriendRequests {
                context.delete(request)
            }
            try context.save()
        } catch {
            print("Error deleting friend requests from Core Data")
        }
    }
    
    //###########################################################//
    
    func removeFriendsFromXMPP() {
        // Get all friends' JIDs from the roster
        let allFriendsJIDs = XMPPController.shared.xmppRoster.xmppRosterStorage.jids(for: XMPPController.shared.xmppStream)

        // Loop through the list of friends' JIDs
        for friendJID in allFriendsJIDs {
            // Remove the friend from the roster
            XMPPController.shared.xmppRoster.removeUser(friendJID)

            // Unsubscribe from the friend's presence
            let unsubscribePresence = XMPPPresence(type: "unsubscribe", to: friendJID)
            XMPPController.shared.xmppStream.send(unsubscribePresence)

            // Cancel the friend's subscription to your presence
            let unsubscribedPresence = XMPPPresence(type: "unsubscribed", to: friendJID)
            XMPPController.shared.xmppStream.send(unsubscribedPresence)
        }
    }
    
    //###########################################################//
    
    @objc private func clearAllMessagesTapped() {
        
        do{
            let messages = try context.fetch(XMPPMessageEntity.fetchRequest())
            
            if !messages.isEmpty {
                // Iterate through messages and remove those that are more than 24 hours old
                for message in messages {
                    
                    context.delete(message)
                    try? context.save()
                }
            } else {
                print("Messages are already empty\n")
            }
        }
        catch{
            print("--Error deleting all messages--\n\n AdminPrototypeViewController: clearAllMessages()")
        }
        
    }
    
    //###########################################################//
    
    @objc private func logoutTapped() {
        //resets all the deafult values for userJID to nil
        
        defaults.set(nil, forKey: "savedUserJID")
        
        //turns the flag for being "logged in" off
        
        defaults.set(false, forKey: "logged_in")
        
        XMPPController.shared.disconnectStream()
        
        //Loads the Login ViewController
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
//######################################################################################################################//



