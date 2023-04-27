//
//  MessagesViewController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/16/23.
//

import UIKit
import SwiftUI
import XMPPFramework
import CoreData

class MessagesViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //############################################################################################################################//
    //#                                             Utilities and References                                                     #//
    //############################################################################################################################//
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    var tableView = UITableView()
    
    var selectedSender: String = ""
    
    let user = XMPPJID(string: XMPPController.shared.userJID)
    
    var messages: [(sender: String, body: String, timestamp: Date)] = []
    
    var messagesFromSender:[XMPPMessageEntity] = []
    
    var allMessages:[XMPPMessageEntity]?
    
    var timer: Timer?
    
    var messageInputTopConstraint: NSLayoutConstraint!
    
    private var isViewVisible: Bool = false
    
    private var messageTextField: UITextField!
    
    private var sendButton: UIButton!
    
    private var bottomConstraint: NSLayoutConstraint!
    
    //############################################################################################################################//
    //#                                                  Main Functions                                                          #//
    //############################################################################################################################//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fillMessages()
        manageViews()
        createTableView()
        setupMessageInputView()
        setupNavBar()
        addDismissKeyboardTapGesture()
    }
    
    //###########################################################//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for message in messagesFromSender {
            if let sender = message.sender, let body = message.body {
                print("From: \(sender)\nBody:\(body)")
            }
        }
    }
    
    //###########################################################//

    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(fetchNewMessages), userInfo: nil, repeats: true)
        super.viewWillAppear(animated)
        isViewVisible = true
        addKeyboardObservers()
    }
    
    //###########################################################//
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewVisible = false
        removeKeyboardObservers()
        if self.isMovingFromParent {
            deleteMessagesFromCoreData()
            messages.removeAll()
        }
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
        tableView.frame = CGRectMake(0, (view.height/2)-310, view.width, view.height*0.7)
    }
    
    //###########################################################//
    
    func manageViews(){
        view.addSubview(tableView)
    }
    
    //###########################################################//
    
    func setupNavBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .default
        title = selectedSender.capitalized
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Change the title color
            .font: UIFont.systemFont(ofSize: 24) // Change the font size
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward")?.withTintColor(UIColor.black)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")?.withTintColor(UIColor.black)
        let backButton = UIBarButtonItem()
         backButton.title = ""
        backButton.tintColor = UIColor.black
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    //###########################################################//
    
    private func addDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
    }
    
    //###########################################################//
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != sendButton
    }
    
    //###########################################################//

    @objc private func keyboardWillShow(notification: Notification) {
        view.layer.removeAllAnimations()
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        messageInputTopConstraint.constant = -keyboardFrame.height + 90
        view.layoutIfNeeded()
    }
    
    //###########################################################//

    @objc private func keyboardWillHide(notification: Notification) {
        messageInputTopConstraint.constant = 20
        view.layoutIfNeeded()
    }
    
    //###########################################################//
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //###########################################################//
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //###########################################################//
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //############################################################################################################################//
    //#                                                 Helper Functions                                                         #//
    //############################################################################################################################//
    
    func fillMessages() {
        for message in messagesFromSender {
            if let sender = message.sender, let body = message.body {
                let messageContents = (sender: sender, body: body, timestamp: Date())
                messages.append(messageContents)
            }
        }
    }
    
    //###########################################################//
    
    @objc func fetchNewMessages() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<XMPPMessageEntity> = XMPPMessageEntity.fetchRequest()

        do {
            let fetchedMessages = try context.fetch(fetchRequest)
            
            for fetchedMessage in fetchedMessages {
                if let sender = fetchedMessage.sender, let body = fetchedMessage.body {
                    if sender == selectedSender {
                        let messageContents = (sender: sender, body: body, timestamp: Date())
                        if !messages.contains(where: { $0.sender == sender && $0.body == body }) {
                            messages.append(messageContents)
                        }
                    }
                }
            }
            
            let currentDate = Date()
            let indicesToRemove = messages.enumerated().compactMap { (index, message) -> Int? in
                let elapsedTime = currentDate.timeIntervalSince(message.timestamp)
                return elapsedTime > 5.0 ? index : nil
            }
            
            // Call `hideAndDeleteCellsAtIndices()` with the indices of messages older than 5 seconds
            hideAndDeleteCellsAtIndices(indicesToRemove)
            
            DispatchQueue.main.async {
                if self.isViewVisible {
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("--Error fetching messages from Core Data--\n\nMessagesViewController: fetchNewMessages()")
        }
    }

    
    //###########################################################//
    
    func hideAndDeleteCells() {
        
        guard view.window != nil else {
            return
        }
        
        // Hide cells with animation
        UIView.animate(withDuration: 0.3, animations: {
            for cell in self.tableView.visibleCells {
                cell.alpha = 0.0
            }
        }, completion: { _ in
            // Delete cells after hiding
            self.deleteMessagesFromCoreData()
            self.messages.removeAll()
            self.tableView.reloadData()
        })
    }
    
    //###########################################################//
    
    func hideAndDeleteCellsAtIndices(_ indices: [Int]) {
        guard view.window != nil else {
            return
        }

        // Hide cells with animation
        UIView.animate(withDuration: 0.3, animations: {
            for index in indices {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                    cell.alpha = 0.0
                }
            }
        }, completion: { _ in
            // Add a delay before deleting cells
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.isViewVisible {
                    self.deleteMessagesFromCoreData(at: indices)
                    for index in indices.sorted(by: >) {
                        self.messages.remove(at: index)
                    }
                    self.tableView.deleteRows(at: indices.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                }
            }
        })
    }
    
    //###########################################################//
    
    func deleteMessagesFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        for message in self.messages {
            let fetchRequest: NSFetchRequest<XMPPMessageEntity> = XMPPMessageEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "sender == %@ AND body == %@", message.sender, message.body)

            do {
                let fetchedMessages = try context.fetch(fetchRequest)
                for fetchedMessage in fetchedMessages {
                    context.delete(fetchedMessage)
                }
                try context.save()
            } catch {
                print("--Error deleting messages from Core Data--\n\nMessagesViewController: deleteMessagesFromCoreData()")
            }
        }
    }
    
    //###########################################################//
    
    func deleteMessagesFromCoreData(at indices: [Int]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        for index in indices {
            let messageToDelete = messages[index]
            let fetchRequest: NSFetchRequest<XMPPMessageEntity> = XMPPMessageEntity.fetchRequest()
            let senderPredicate = NSPredicate(format: "sender == %@", messageToDelete.sender)
            let bodyPredicate = NSPredicate(format: "body == %@", messageToDelete.body)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [senderPredicate, bodyPredicate])

            do {
                let fetchedMessages = try context.fetch(fetchRequest)
                for message in fetchedMessages {
                    context.delete(message)
                }
                try context.save()
            } catch {
                print("--Error deleting messages from Core Data--\n\nMessagesViewController: deleteMessagesFromCoreData(at indices: [Int])")
            }
        }
    }
    
    //############################################################################################################################//
    //#                                                   UI Elements                                                            #//
    //############################################################################################################################//
    
    //Creates the table view
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.register(MessageBubbleCell.self, forCellReuseIdentifier: "MessageBubbleCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if self.isViewVisible {
                self.hideAndDeleteCells()
            }
        }
    }
    
    //###########################################################//
    
    private func setupMessageInputView() {
        messageTextField = UITextField()
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.delegate = self
        messageTextField.borderStyle = .bezel
        messageTextField.layer.cornerRadius = 12
        messageTextField.placeholder = "Encrypted message..."
        view.addSubview(messageTextField)

        sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(sendButton)

        messageInputTopConstraint = messageTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20)

        NSLayoutConstraint.activate([
                messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
                messageTextField.heightAnchor.constraint(equalToConstant: 40),

                sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                sendButton.bottomAnchor.constraint(equalTo: messageTextField.bottomAnchor),
                sendButton.widthAnchor.constraint(equalToConstant: 60),
                sendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),

                messageInputTopConstraint
        ])
    }
    
    //############################################################################################################################//
    //#                                                 Button Functions                                                         #//
    //############################################################################################################################//
    
    @objc private func sendButtonTapped() {
        // Handle send button tap, e.g. send the message, clear the text field, etc.
        print("Message: \(messageTextField.text ?? "")")
        
        guard let message = messageTextField.text, !message.isEmpty else {
            return
        }
        let messageContents = (sender: user?.user ?? "", body: message, timestamp: Date())
        messages.append(messageContents)
        DispatchQueue.main.async {
            if self.isViewVisible {
                self.tableView.reloadData()
            }
        }
        
        //XMPP referenced from singleton class XMPPController to send the message
        let jidString = "\(selectedSender)@cipher.com"
        XMPPController.shared.sendMessage(message: message, recipient: jidString)
        
        messageTextField.text = ""
    }
    
}
//############################################################################################################################//
//#                                               Extensions                                                                 #//
//############################################################################################################################//

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Allocates set number of rows for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    //###########################################################//
    
    //Returns a cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBubbleCell", for: indexPath) as! MessageBubbleCell
        let message = messages[indexPath.row]
        
        if message.sender == user?.user {
            cell.senderMessageBubbleView.isHidden = false
            cell.senderMessageLabel.text = message.body
            
            cell.recipientMessageBubbleView.isHidden = true
        } else {
            cell.senderMessageBubbleView.isHidden = true
            
            cell.recipientMessageBubbleView.isHidden = false
            cell.recipientMessageLabel.text = message.body
        }
        
        return cell
        
    }
    //############################################################################################################################//
}
