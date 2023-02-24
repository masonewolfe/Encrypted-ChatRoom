//
//  MessagesViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/16/23.
//

import UIKit
import XMPPFramework

class MessagesViewController: UIViewController {
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var tableView = UITableView()
    var messages:[XMPPMessageEntity]?
    
    //############################################################################################################################//
    //#                                                  Main Functions                                                          #//
    //############################################################################################################################//

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchMessages()
        manageViews()
        createTableView()
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
    //#                                            View Management Fucntions                                                     #//
    //############################################################################################################################//
    
    func configureViewLayout(){
        tableView.frame = view.bounds
    }
    
    //###########################################################//
    
    func manageViews(){
        view.addSubview(tableView)
    }
 
    //############################################################################################################################//
    //#                                                   UI Elements                                                            #//
    //############################################################################################################################//
    
    //Creates the table view
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.clipsToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Value1Cell")
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    func fetchMessages(){
        do{
            self.messages = try context.fetch(XMPPMessageEntity.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData ()
            }
        }
        catch{
            print("Error fetching messages")
        }
    }
}

//############################################################################################################################//
//#                                               Utilities and References                                                   #//
//############################################################################################################################//

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    /*
        var i = 0
        var count = 0
        while i < self.messages!.count {
            let message = self.messages![i]
            if message.recipient == XMPPController.shared.userJID{
                count += 1
            }
            i += 1
        }
        return count
     */
        return messages!.count
    }
    
    //###########################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Value1Cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            let message = self.messages![indexPath.row]
    
            if message.recipient == XMPPController.shared.userJID{
                var content = cell.defaultContentConfiguration()
                content.text = message.sender
                content.secondaryText = String("Delivered ... ago")
                cell.contentConfiguration = content
            }
            else{
                print("No recipient data")
            }
        }
        else{
            print("Any version before iOS 14.0 cannot display the table")
        }
        
        return cell
    }
}

//############################################################################################################################//


