//
//  XMPPController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import Foundation
import XMPPFramework
import CoreData
import KeychainSwift

class XMPPController: NSObject, XMPPStreamDelegate, XMPPRosterDelegate, XMPPvCardTempModuleDelegate {
    
    //############################################################################################################################//
    //#                                               Utilities and References                                                   #//
    //############################################################################################################################//
    
    //Allows for global use of the XMPP Controller throughout the projects views
    static let shared = XMPPController()
    
    //Allows access to default values
    let defaults = UserDefaults.standard
    
    //Allows access to Core Data Storage
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Core Data Entity
    var messages:[XMPPMessageEntity]?
    
    var managedObjectContext: NSManagedObjectContext!
    
    private override init(){
        super.init()
    }

    //############################################################################################################################//
    //#                                                 Stream Elements                                                          #//
    //############################################################################################################################//
    
    var xmppStream = XMPPStream()
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppvCardTempModule: XMPPvCardTempModule!
    var myPresence = false
    var xmppRoster: XMPPRoster!
    let hostName = "3.91.204.251"
    let hostPort = 5222
    var userJID = ""
    var password = ""
    
    //############################################################################################################################//
    //#                                                 Connection Functions                                                     #//
    //############################################################################################################################//

    //Function to connect XMPP Stream
    
    func connect() {
        
        if(userJID == "") {
            
            let keychain = KeychainSwift()
            
            XMPPController.shared.userJID = self.defaults.string(forKey: "savedUserJID")!
            
            if let username = XMPPJID(string: XMPPController.shared.userJID)?.user{
                let keyPass = "\(username)Password"
                if let retrievedPassword = keychain.get(keyPass) {
                    print("Retrieved password: \(retrievedPassword)")
                    XMPPController.shared.password = retrievedPassword
                }
                else{
                    print("--Error retrieving password--")
                }
            }
            else {
                print("--Error retrieving username--")
            }
            
        }

        xmppStream.myJID = XMPPJID(string: userJID)
        xmppStream.hostName = hostName
        xmppStream.hostPort = UInt16(hostPort)
        
        xmppStream.removeDelegate(self, delegateQueue: DispatchQueue.main)
        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        // Connect to the XMPP server
        do {
            if xmppStream.isAuthenticated {
                print("Stream is already authenticated")
            }
            else{
                try xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
                if xmppStream.isConnecting{
                    print("\nConnecting to the XMPP Server...\n")
                }
            }
        } catch {
            print("\nError connecting to XMPP server: \(error)\n")
        }
    }
    
    //########################################################################//
    
    //Disconnects the stream
    
    func disconnectStream() {
        if xmppStream.isConnected {
            let presence = XMPPPresence(type: "unavailable")
            self.myPresence = false
            xmppStream.send(presence)
            self.xmppRoster.deactivate()
            xmppStream.disconnect()
            
            print("\nDisconnecting from XMPP Server...\n")
        }
    }
    
    //########################################################################//
    
    //Function to authenticate the user, if unable, prints error
    
    func authenticate(){
 
        do {
            try xmppStream.authenticate(withPassword: password)
            if xmppStream.isAuthenticating{
                print("Authenticating with the server...\n")
            }
        } catch {
            print("\nError authenticating with XMPP server: \(error)\n")
        }
    }
    //########################################################################//
    
    //Function to setup roster and roster storage for friends/subscriptions
    
    func setupRoster() {
      
        self.xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        //self.xmppRoster.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppRoster.autoClearAllUsersAndResources = true
        self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = false
        self.xmppRoster.activate(xmppStream)
        self.xmppRoster.fetch()
    }
    
    //########################################################################//
    
    func setupvCardModule() {
        let vCardStorage = XMPPvCardCoreDataStorage.sharedInstance()
        xmppvCardTempModule = XMPPvCardTempModule(vCardStorage: vCardStorage!, dispatchQueue: DispatchQueue.main)
        xmppvCardTempModule.activate(self.xmppStream)
        xmppvCardTempModule.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    //########################################################################//
    
    func requestvCard(for userJID: String) {
        guard let jid = XMPPJID(string: userJID) else {
            print("Invalid JID: \(userJID)")
            return
        }
        xmppvCardTempModule.fetchvCardTemp(for: jid, ignoreStorage: false)
    }
    
    //########################################################################//
    
    //Will send an http request to the server with json body [user,host,password]
    
    func registerUser(user: String, host: String, password: String) {
        
        //Setting up http request
        let apiUrl = "http://3.91.204.251:5281"
        let httpController = HTTPController(serverURL: apiUrl)
        let path = "/api/register"
        let parameters: [String: Any] = [
            "user": user,
            "host": host,
            "password": password
        ]
        httpController.post(path: path, parameters: parameters) { (data, response, error) in
            
            //Handling the response
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("HTTP response code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Registration successful: \(responseString)")
                    
                    let keyGen = KeyManager()
                    let keyTag = "com.cipher.\(user).privateKey"
                    let (publicKey, privateKey, publicKeyEncoded): (SecKey?, SecKey?, String?) = keyGen.generateRSA(privateKeyTag: keyTag)
                    if let _ = publicKey, let _ = privateKey, let publicKeyEncoded = publicKeyEncoded {
                        print("PublicKey Base64 Encoded: \(publicKeyEncoded)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            keyGen.sendKey(user: user, publicKeyEncoded: String(describing: publicKeyEncoded))
                        }
                    } else {
                        print("Error generating RSA key pair")
                    }
                } else {
                    print("Registration failed")
                }
            }
        }
    }
    
    //########################################################################//
    
    func changePassword(user: String, host: String, newPassword: String) {
        // Set up the HTTP request
        let apiUrl = "http://3.91.204.251:5281"
        let httpController = HTTPController(serverURL: apiUrl)
        let path = "/api/change_password"
        let parameters: [String: Any] = [
            "user": user,
            "host": host,
            "newpass": newPassword
        ]
        httpController.post(path: path, parameters: parameters) { (data, response, error) in
            // Handle the response
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("HTTP response code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Password change successful: \(responseString)")
                } else {
                    print("Password change failed")
                }
            }
        }
    }

    
    //########################################################################//
    
    //Send a subscription request
/*
    func sendSubscriptionRequest(to jid: XMPPJID, xmppStream: XMPPStream) {
        
        let username = jid.user
        
        do {
            let fetchedRequests = try context.fetch(FriendRequest.fetchRequest())
            
            for fetchedRequest in fetchedRequests {
                if fetchedRequest.username == username {
                    if fetchedRequest.friends == true {
                        print("\nYou are already friends with this user\n")
                       return
                    }
                    else {
                        print("Request already sent")
                       return
                    }
                    
                }
            }

        } catch {
            print("Error.. ")
        }
        
        
        // Generate an AES key
        let aesKey = KeyManager.shared.generateAES()!
        
        // Save the friend request to CoreData
        let friendRequest = FriendRequest(context: self.context)
        friendRequest.username = jid.user
        friendRequest.base64EncodedEncryptedAESKey = aesKey.base64EncodedString()
        friendRequest.friends = false
        
        // Encrypt the AES key with the recipient's RSA public key
        KeyManager.shared.encryptAESKey(aesKey: aesKey, withRSAKey: jid.user!) { encryptedAESKey in
            guard let encryptedAESKey = encryptedAESKey else {
                print("Error encrypting AES key with RSA")
                return
            }
            
            // Generate a random IV and store in CoreData
            let iv = KeyManager.shared.generateRandomBytes(length: 16)!
            friendRequest.iv = iv.base64EncodedString()

            // Append the encrypted AES key and the IV
            let combinedData = encryptedAESKey + iv

            // Base64 encode the combined data (encrypted AES key + IV)
            let base64EncodedCombinedData = combinedData.base64EncodedString()

            // Create a presence stanza with the base64 encoded combined data as the status
            let presence = XMPPPresence(type: "subscribe", to: jid)
            presence.addChild(DDXMLElement(name: "status", stringValue: base64EncodedCombinedData))
            
            // Send the presence stanza
            xmppStream.send(presence)

            do {
                try self.context.save()
            } catch {
                print("\nError saving friend request: \(error)\n")
            }
        }
    }*/
    func sendSubscriptionRequest(to jid: XMPPJID, xmppStream: XMPPStream) {
        let username = jid.user

        do {
            let fetchedRequests = try context.fetch(FriendRequest.fetchRequest())

            for fetchedRequest in fetchedRequests {
                if fetchedRequest.username == username {
                    if fetchedRequest.friends == true {
                        print("\nYou are already friends with this user\n")
                        return
                    } else {
                        print("Request already sent")
                        return
                    }
                }
            }
        } catch {
            print("Error.. ")
        }

        // Generate an AES key
        let aesKey = KeyManager.shared.generateAES()!

        // Save the friend request to CoreData
        let friendRequest = FriendRequest(context: self.context)
        friendRequest.username = jid.user
        friendRequest.base64EncodedEncryptedAESKey = aesKey.base64EncodedString()
        friendRequest.friends = false

        // Generate a random IV and store in CoreData
        let iv = KeyManager.shared.generateRandomBytes(length: 16)!
        friendRequest.iv = iv.base64EncodedString()

        // Combine the AES key and the IV
        let combinedData = aesKey + iv
        print("Comined Data: \(combinedData)")

        // Encrypt the combined data (AES key + IV) with the recipient's RSA public key
        KeyManager.shared.encryptAESKey(aesKey: combinedData, withRSAKey: jid.user!) { encryptedCombinedData in
            guard let encryptedCombinedData = encryptedCombinedData else {
                print("Error encrypting combined data with RSA")
                return
            }

            // Base64 encode the encrypted combined data
            let base64EncodedEncryptedCombinedData = encryptedCombinedData.base64EncodedString()

            // Create a presence stanza with the base64 encoded encrypted combined data as the status
            let presence = XMPPPresence(type: "subscribe", to: jid)
            presence.addChild(DDXMLElement(name: "status", stringValue: base64EncodedEncryptedCombinedData))

            // Send the presence stanza
            xmppStream.send(presence)

            do {
                try self.context.save()
            } catch {
                print("\nError saving friend request: \(error)\n")
            }
        }
    }

    
    //########################################################################//
    
    func acceptSubscriptionRequest(from jid: XMPPJID, xmppStream: XMPPStream) {
        let presence = XMPPPresence(type: "subscribed", to: jid)
        xmppStream.send(presence)
        
    }
    
    //########################################################################//
    
    func denySubscriptionRequest(from jid: XMPPJID, xmppStream: XMPPStream) {
        let presence = XMPPPresence(type: "unsubscribed", to: jid)
        xmppStream.send(presence)
    }


    //########################################################################//
    
    //Funtion to send a message
    /*
    func sendMessage(message: String, recipient: String) {
            let jid = XMPPJID(string: recipient)
            let user = jid?.user
            let messageElement = XMPPMessage(type: "chat", to: jid)
        KeyManager.shared.getKey(username: user!) { publicKey in
            if let publicKey = publicKey {
                if let encryptedData = KeyManager.shared.encryptMessage(message: message, publicKey: publicKey) {
                    let messageData = encryptedData.base64EncodedString()
                    messageElement.addBody(messageData)
                    //print("Encrypted message: \(messageData)")
                    self.xmppStream.send(messageElement)
                }
                else {
                    print("Error encrypting message")
                }
            }
            else {
                print("Error fetching public key")
            }
        }
    }*/
    
    func sendMessage(message: String, recipient: String) {
        let jid = XMPPJID(string: recipient)
        let user = jid?.user

        if let username = user {
            if let encryptedData = KeyManager.shared.AESencryptMessage(username: username, message: message) {
                let encryptedMessage = encryptedData.base64EncodedString()

                let messageElement = XMPPMessage(type: "chat", to: jid)
                messageElement.addBody(encryptedMessage)
                self.xmppStream.send(messageElement)
            } else {
                print("\nError encrypting and sending message\n")
            }
        } else {
            print("\nError getting user from JID\n")
        }
    }
    
    func clearNonFriendRequests() {
        // Create a fetch request for FriendRequest instances with friends set to false
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "friends == NO")

        do {
            // Fetch the matching FriendRequest instances
            let nonFriendRequests = try self.context.fetch(fetchRequest)

            // Delete each non-friend request
            for request in nonFriendRequests {
                self.context.delete(request)
            }

            // Save the context after deleting the requests
            try self.context.save()
            print("\nDeleted all non-friend requests\n")
        } catch {
            print("\nError fetching or deleting non-friend requests: \(error)\n")
        }
    }


    //############################################################################################################################//
    //#                                             Delegate Methods                                                             #//
    //############################################################################################################################//
    
    //Executes after the stream connects
    //Will start authentication
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
            print("Connected to XMPP server\n")
        
            if userJID != "" {
                authenticate()
            }
    }
    
    //########################################################################//
    
    //Executes when the stream disconnects
    //Deactivates the roster
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
  
        if xmppRoster != nil{
            self.xmppRoster.deactivate()
        }
        
        
        print("Disconnected from XMPP Server\n")
    }
    
    //########################################################################//
    
    //Executes when stream authenticates
    //Sends user presence to the server
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("Authenticated with XMPP server\n")
        
        //Setup of the XMPPRoster
        setupRoster()
        //sendSubscribePresenceFromUserRequest()
        
        // Send presence to the server to indicate that the user is online
        if let presence = defaults.object(forKey: "savedPresence") as? Bool {
            self.myPresence = presence
        }
        else {
            self.myPresence = true
        }
        let presence = XMPPPresence()
        self.xmppStream.send(presence)
    }
    
    //########################################################################//
    
    //Executes if stream is unable to authenticate
    //Sends error to console
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("\nError authenticating with XMPP server: \(error)\n")
    }
    
    //########################################################################//
    
    //Executes after roster has been populated
    //Prints friends from roster
    
    func xmppRosterDidEndPopulating(_ sender: XMPPRoster){
        print("Friends:\(xmppRoster.xmppRosterStorage.jids(for: xmppStream))")
    }
    
    //########################################################################//
    
    //Executes when roster changes
    //Prints updated list of friends
    
    func xmppRosterDidChange(_ sender: XMPPRoster){
        let roster = sender.xmppRosterStorage
        print("Updated friends: \(roster.jids(for: xmppStream))")
    }
    
    //########################################################################//
    
    //Executes when a message is recieved
    //Saves message to local storage until viewed
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        print("\n---Incoming Message!---\n")
        let newMessage = XMPPMessageEntity(context: context)
        guard let cipherMessage = Data(base64Encoded: message.body!) else {
            print("Error decoding Base64 cipher message")
            return
        }
        
        let sender = message.from?.user
        //let messageBody = KeyManager.shared.decryptMessage(encryptedData: cipherMessage, privateKeyTag: keyTag)
        let messageBody = KeyManager.shared.decryptMessageWithAES(messageData: cipherMessage, sender: sender!)
        print("\nMessage Decrypted!\n")
        newMessage.body = messageBody
        
        newMessage.sender = message.from?.user
        newMessage.recipient = message.to?.user
        newMessage.read = false
        newMessage.timeStamp = Date()
        
        do {
            try self.context.save()
        } catch {
            print("Error saving message data")
        }
        
        if let sender = newMessage.sender, let body = newMessage.body {
            print("\n+-Message Received-+\n")
            print("From: \(sender)")
            print("Message Body: \(body)\n")
        }

        // Check if the app is running in the background
        if UIApplication.shared.applicationState == .background {
            // If the app is running in the background, create a local notification
            let content = UNMutableNotificationContent()
            content.title = "New Message"
            content.body = "You have a new message from \(newMessage.sender ?? "Unknown sender")" // You can customize this with the actual message content
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("\nError scheduling local notification: \(error)\n")
                }
            }
        } else {
            // If the app is active, update the UI or handle the message as you normally would
            // ...
        }
    }
    
    //########################################################################//
    
    //Executes when a users presence is recieved
    //Saves online status of user and prints to console
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        let user = presence.from?.bare
        let status = presence.type
        
        if presence.type == "available"{
            defaults.set("online", forKey: user!)
            
        }
        if presence.type == "unavailable"{
            defaults.set("offline", forKey: user!)
        }
        
        if presence.type == "subscribe" {
            xmppRoster(self.xmppRoster, didReceivePresenceSubscriptionRequest: presence)
        }
        
        if presence.type == "subscribed" {
            do {
                let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@", (presence.from?.user)!)
                let senders = try context.fetch(fetchRequest)
                if let sender = senders.first {
                    sender.friends = true
                    try context.save()
                }
                
            } catch {
                print("\n--Error updating friend status--\n")
            }
            
            print("\nPresence Update:")
            print("---User: \(user ?? "No User")")
            print("---Status: \(status ?? "No Status")\n")
        }
    }
    
    //########################################################################//
    
    //Executes when a message is sent
    //Prints confirmation to console
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("\nMessage sent\n")
    }
    
    //########################################################################//
    
    func xmppStream(_ sender: XMPPStream, didSend presence: XMPPPresence) {
        print("\nDid send presence: \(presence)\n")
    }
    
    //########################################################################//

    func xmppStream(_ sender: XMPPStream, didNotSend presence: XMPPPresence, dueToError error: Error?) {
        print("\nFailed to send presence: \(presence), error: \(String(describing: error))\n")
    }

    
    //########################################################################//
    
    func xmppRoster(_ sender: XMPPRoster, didReceivePresenceSubscriptionRequest presence: XMPPPresence) {
        let userJID = presence.from
        let username = userJID!.user
        var exists = false
        do {
            let reqs = try context.fetch(FriendRequest.fetchRequest())
            
            for req in reqs {
                if req.username == username{
                    exists = true
                }
            }
        }
        catch {
            print("Error fetching messages")
        }
        
        if exists == true {
            print("Request exists")
            return
        }
        print("No")
        
        // Extract the AES key from the status tag
        let statusElement = presence.elements(forName: "status").first
        let encryptedAESKeyIV = statusElement?.stringValue
        
        guard let combinedData = Data(base64Encoded: encryptedAESKeyIV!) else {
                print("Error decoding base64CombinedData")
                return
            }
        
        print("Combined data length: \(combinedData)")
        
        
        let privateKey: SecKey?
        if let user = XMPPJID(string: self.userJID)?.user {
            privateKey = KeyManager.shared.getPrivateKeyFromKeychain(privateKeyTag: "com.cipher.\(user).privateKey")
        } else {
            print("Unable to create key tag: didRecievePresenceSubscriptionRequest()")
            return
        }
        
        let decryptedCombinedData = KeyManager.shared.decryptAESKeyWithRSA(privateKey: privateKey!, encryptedAESKeyData: combinedData)
        let AESKeyData = decryptedCombinedData!.subdata(in: 0..<16)
        let ivData = decryptedCombinedData!.subdata(in: 16..<(decryptedCombinedData!.count))

        // Save the friend request to CoreData
        let friendRequest = FriendRequest(context: self.context)
        friendRequest.username = username
        friendRequest.friends = false
        friendRequest.base64EncodedEncryptedAESKey = AESKeyData.base64EncodedString()
        friendRequest.iv = ivData.base64EncodedString()

        do {
            try self.context.save()
            print("\nSaving Friend Request\n")
        } catch {
            print("\nError saving friend request: \(error)\n")
        }

        // Handle the subscription request (e.g., show a UI alert asking the user to accept or deny)
        // You can now fetch the friend request from CoreData when the user chooses to accept or deny the request
    }

    
    //########################################################################//
    
    func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule, didReceivevCardTemp vCardTemp: XMPPvCardTemp, for jid: XMPPJID) {
        // Handle the received vCardTemp object, e.g., display the user's nickname
        let nickname = vCardTemp.nickname
        //let profilePic = vCardTemp.photo
        
        print("Nickname for \(jid): \(nickname ?? "No nickname set")")
    }
    
    //########################################################################//
    
    func xmppvCardTempModuleDidUpdateMyvCard(_ vCardTempModule: XMPPvCardTempModule, vCardTemp: XMPPvCardTemp) {
            // Handle the updated vCardTemp object, e.g., display the updated user's nickname
            let updatedNickname = vCardTemp.nickname
            print("Updated my nickname: \(updatedNickname ?? "No nickname set")")
        }
    
    //########################################################################//
    
    private func xmppvCardTempModule(_ vCardTempModule: XMPPvCardTempModule, failedToReceivevCardTempFor jid: XMPPJID, error: Error) {
           // Handle the error while receiving vCardTemp object
           print("Failed to receive vCardTemp for \(jid): \(error.localizedDescription)")
       }
    
    
    //############################################################################################################################//
    
}



