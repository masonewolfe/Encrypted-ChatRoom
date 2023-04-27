//
//  FriendRequestsViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 4/19/23.
//

import UIKit
import CoreData
import XMPPFramework
import Combine

class FriendRequestsViewController: UIViewController{
    
    //############################################################################################################################//
    //#                                               Utilities and References                                                   #//
    //############################################################################################################################//
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableView = UITableView()
    
    var requests: [(sender: String, friends: Bool)] = []
    
    private var cancellables: [AnyCancellable] = []
 
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        modalPresentationStyle = .overFullScreen
        fetchRequests()
        setupBlurEffect()
        manageViews()
        calibrateButtons()
        configureViewLayout()
        createTableView()
    }
    
    //###########################################################//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //############################################################################################################################//
    //#                                              View Management Functions                                                   #//
    //############################################################################################################################//
    
    func manageViews() {
        view.addSubview(tableView)
        view.addSubview(dismissButton)
    }
    
    //###########################################################//
    
    func configureViewLayout() {
        let buttonSize: CGFloat = 40
        let buttonMargin: CGFloat = 16
        dismissButton.frame = CGRect(x: view.width - buttonSize - buttonMargin, y: buttonSize+buttonMargin, width: buttonSize, height: buttonSize)
        
        let tableViewTop = dismissButton.frame.origin.y + dismissButton.frame.size.height + buttonMargin
        tableView.frame = CGRect(x: 0, y: tableViewTop, width: view.width, height: view.height - tableViewTop)
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
    }
    
    //###########################################################//
    
    func dismissFriendRequestViewController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    @objc func dismissButtonTapped() {
            dismissFriendRequestViewController()
        }

    @objc func acceptButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
               let request = requests[indexPath.row]
               let username = request.sender

               // Accept friend request
               let jid = XMPPJID(string: "\(username)@cipher.com")
               XMPPController.shared.acceptSubscriptionRequest(from: jid!, xmppStream: XMPPController.shared.xmppStream)

               // Update CoreData
               let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "username == %@", username)
               do {
                   let fetchedRequests = try context.fetch(fetchRequest)
                   if let fetchedRequest = fetchedRequests.first {
                       fetchedRequest.friends = true
                       
                       try context.save()
                   }
               } catch {
                   print("--Error updating friend request in Core Data--\n\nFriendRequestViewController: acceptButtonTapped()")
               }

               // Remove request from the list and update the table view
               requests.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .automatic)
       }
    
    @objc func denyButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let request = requests[indexPath.row]
        let username = request.sender
        
        // Deny friend request
        let jid = XMPPJID(string: "\(username)@cipher.com")
        XMPPController.shared.denySubscriptionRequest(from: jid!, xmppStream: XMPPController.shared.xmppStream)
        
        // Remove the friend request from CoreData
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        do {
            let fetchedRequests = try context.fetch(fetchRequest)
            if let fetchedRequest = fetchedRequests.first {
                context.delete(fetchedRequest)
                try context.save()
            }
        } catch {
            print("--Error deleting friend request from Core Data--\n\nFriendRequestViewController: acceptButtonTapped()")
        }
        
        // Remove request from the list and update the table view
        requests.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
     
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    func fetchRequests() {
        
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "friends == NO")
        do {
            let fetchedRequests = try context.fetch(fetchRequest)
            
            for fetchedRequest in fetchedRequests {
                if fetchedRequest.username != nil{
                    let requestContents = (sender: fetchedRequest.username!, friends: fetchedRequest.friends)
                    requests.append(requestContents)
                }
            }
            tableView.reloadData() // Reload the table view data to show the fetched requests
        } catch {
            print("--Error fetching messages from Core Data--\n\n FriendRequestViewController: fetchRequests()")
        }
    }
    
    //############################################################################################################################//
    //#                                                    UI Elements                                                           #//
    //############################################################################################################################//
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: .arrowRight), for: .normal)
        button.setTitleColor(.init(red: 100, green: 100, blue: 100, alpha: 1.0), for: .normal)
        
        return button
    }()
    
    //###########################################################//
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.clipsToBounds = true
        tableView.allowsSelection = false
        tableView.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: "FriendRequestCell")
    }
    
    //###########################################################//
    
}

//############################################################################################################################//
//#                                                    Extensions                                                            #//
//############################################################################################################################//

extension FriendRequestsViewController: UITableViewDelegate, UITableViewDataSource {

    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    //###########################################################//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //###########################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestTableViewCell

        let request = requests[indexPath.row]
        cell.titleLabel.text = request.sender.capitalized
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.0)

        // Create a custom view for accessoryView
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))

        // Create accept button
        let acceptButton = UIButton(type: .custom)
        acceptButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        acceptButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        acceptButton.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        acceptButton.setTitleColor(UIColor.white, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
        
        // Create deny button
        let denyButton = UIButton(type: .custom)
        denyButton.frame = CGRect(x: 30, y: 0, width: 30, height: 44)
        denyButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        denyButton.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        denyButton.setTitleColor(UIColor.white, for: .normal)
        denyButton.addTarget(self, action: #selector(denyButtonTapped(_:)), for: .touchUpInside)
        
        accessoryView.addSubview(acceptButton)
        accessoryView.addSubview(denyButton)
        
        cell.accessoryView = accessoryView
        
        return cell
    }
}

//############################################################################################################################//




