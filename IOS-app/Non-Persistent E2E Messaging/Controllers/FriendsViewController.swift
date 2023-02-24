//
//  Friends.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/7/23.
//

import Foundation
import UIKit
import SwiftUI
import XMPPFramework

class FriendsViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                               Utilities and References                                                   #//
    //############################################################################################################################//
    
    let defaults = UserDefaults.standard
    var tableView = UITableView()
    var friends = [XMPPJID]()
    let newContact = FriendCell()
    
    //############################################################################################################################//
    //#                                                    Main Functions                                                        #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Friends"
        view.backgroundColor = .white
        fetchContacts()
        manageViews()
        createTableView()
    }
    
    //###################################################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //###################################################################################//
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        configureViewLayout()
    }

    //############################################################################################################################//
    //#                                              View Management Functions                                                   #//
    //############################################################################################################################//
    
    func configureViewLayout(){
        tableView.frame = view.bounds
    }
    
    //###################################################################################//
    
    func manageViews(){
        view.addSubview(tableView)
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    struct Cells{
        static let friendCell = "Contact"
    }
    //###################################################################################//
    
    //Will retrieve current subscriptions
    
    func fetchContacts(){
        friends = XMPPController.shared.xmppRosterStorage.jids(for: XMPPController.shared.xmppStream)
        print(friends)
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
        tableView.register(FriendCell.self, forCellReuseIdentifier: Cells.friendCell)
    }
}

//############################################################################################################################//
//#                                                    Extensions                                                            #//
//############################################################################################################################//

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    //###################################################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.friendCell) as? FriendCell
        let currentContact = friends[indexPath.row]
        let status = defaults.string(forKey: currentContact.bare)
        
        cell!.name.text = currentContact.user?.capitalized
        
        cell!.name.text = currentContact.user?.capitalized
        if status == "online"{
            cell?.presenceIndicator.circleColor = UIColor.green
        }
        if status == "offline"{
            cell?.presenceIndicator.circleColor = UIColor.red
        }
        return cell!
    }
}

//############################################################################################################################//
