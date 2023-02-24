//
//  XMPPController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import Foundation
import XMPPFramework
import CoreData

class XMPPController: NSObject, XMPPStreamDelegate, XMPPRosterDelegate{
    
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


    private override init(){
    }
    
    //############################################################################################################################//
    //#                                                 Stream Elements                                                          #//
    //############################################################################################################################//
    
    var xmppStream = XMPPStream()
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var presenceJID: XMPPJID!
    var xmppRoster: XMPPRoster!
    let hostName = "52.188.65.46"
    let hostPort = 5222
    var userJID = ""
    var password = ""
    
    //############################################################################################################################//
    //#                                                 Connection Functions                                                     #//
    //############################################################################################################################//
    
    //Function to connect XMPP Stream
    
    func connect() {
      
        xmppStream.hostName = hostName
        xmppStream.hostPort = UInt16(hostPort)
        xmppStream.myJID = XMPPJID(string: userJID)
        
        xmppStream.removeDelegate(self, delegateQueue: DispatchQueue.main)
        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        // Connect to the XMPP server
        do {
            try xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
            if xmppStream.isConnecting{
                print("Connecting to the XMPP Server...")
            }
        } catch {
            print("Error connecting to XMPP server: \(error)")
        }
    }
    
    //########################################################################//
    
    //Disconnects the stream
    
    func disconnectStream() {
        if xmppStream.isConnected {
            xmppStream.disconnect()
            
            print("Disconnecting from XMPP Server...")
        }
    }
    
    //########################################################################//
    
    //Function to authenticate the user, if unable, prints error
    
    func authenticate(){
        do {
            try xmppStream.authenticate(withPassword: password)
            if xmppStream.isAuthenticating{
                print("Authenticating with the server...")
            }
        } catch {
            print("Error authenticating with XMPP server: \(error)")
        }
    }
    //########################################################################//
    
    //Function to setup roster and roster storage for friends/subscriptions
    
    func setupRoster() {
      
        self.xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        //self.xmppRoster.addDelegate(self, delegateQueue: DispatchQueue.main)
        self.xmppRoster.autoClearAllUsersAndResources = true
        self.xmppRoster.activate(xmppStream)
        self.xmppRoster.fetch()
    }
    
    //########################################################################//
    
    func register(jid: String, userPassword: String){
        /*
         userJID = "register@selfdestructim.com"
         password = "password"
         connect()
         
         let seconds = 2.0
         
         DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
         */
        
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = UInt16(hostPort)
        self.xmppStream.myJID = XMPPJID(string: jid)
        do{
            try self.xmppStream.register(withPassword: userPassword)
        }catch{
            print("no work")
        }
    }
    
    //########################################################################//
    
    //Send a subscription request
    
    func sendSubscribePresenceFromUserRequest(name: String){
        let friend = XMPPJID(string: "\(name)@selfdestructim.com")
        self.xmppRoster.addUser(friend!, withNickname: name)
    }
    
    //########################################################################//
    
    //Funtion to send a message
    
    func sendMessage(message: String, recipient: String) {
        let messageElement = XMPPMessage(type: "chat", to: XMPPJID(string: recipient))
        messageElement.addBody(message)
        self.xmppStream.send(messageElement)
        print("Sent")
    }
    
    //############################################################################################################################//
    //#                                             Delegate Methods                                                             #//
    //############################################################################################################################//
    
    //Executes after the stream connects
    //Will start authentication
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        if xmppStream.isAuthenticating{
            print("Attempted to authenticate twice.")
        }
        else{
            print("Connected to XMPP server")
            if userJID != "" {
                authenticate()
            }
        }
    }
    
    //########################################################################//
    
    //Executes when the stream disconnects
    //Deactivates the roster
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
  
        if xmppRoster != nil{
            self.xmppRoster.deactivate()
        }
        
        print("Disconnected from XMPP Server")
    }
    
    //########################################################################//
    
    //Executes when stream authenticates
    //Sends user presence to the server
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("Authenticated with XMPP server")
        
        //Setup of the XMPPRoster
        setupRoster()
        //sendSubscribePresenceFromUserRequest()
        
        // Send presence to the server to indicate that the user is online
        let presence = XMPPPresence()
        self.xmppStream.send(presence)
    }
    
    //########################################################################//
    
    //Executes if stream is unable to authenticate
    //Sends error to console
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("Error authenticating with XMPP server: \(error)")
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
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage){
        
        let newMessage = XMPPMessageEntity(context: context)
        newMessage.body = message.body
        newMessage.sender = message.from?.bare
        newMessage.recipient = message.to?.user
        
        do{
            try self.context.save()
        }
        catch{
            print("Error saving message data")
        }
        
        print("+-Message Received-+")
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
        print("\nPresence Update:")
        print("---\(user ?? "No User")")
        print("------\(status ?? "No Status")")
    }
    
    //########################################################################//
    
    //Executes when a query is recieved
    //Handles registration
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        guard let query = iq.elements(forName: "query").first,
                 query.xmlns == "jabber:iq:register" else {
               return false
           }
           
        if iq.type == "result" && query.children?.count == 0 {
            // Registration successful
            print("Registration Successful!")
        } else if iq.type == "error" && iq.childElement?.name == "query" {
            // Registration failed
            let errorElement = iq.childElement?.element(forName: "error")
            let errorCode = errorElement?.attributeStringValue(forName: "code") ?? "unknown"
            let errorMessage = errorElement?.attributeStringValue(forName: "message") ?? "Unknown error"
            print("Registration failed with error \(errorCode): \(errorMessage)")
        }
        
        return true
    }
    
    //########################################################################//
    
    //Executes when a message is sent
    //Prints confirmation to console
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("\nMessage sent")
    }

    //########################################################################//
    
    //Executes when a subscription request is recieved
    //Will automatically accept as of now
    
    func xmppRoster(_ sender: XMPPRoster, didReceivePresenceSubscriptionRequest presence: XMPPPresence) {
        let userRequest = presence.from
        print("Friend Request from: \(userRequest!)")
        self.xmppRoster.acceptPresenceSubscriptionRequest(from: userRequest!, andAddToRoster: true)
        print("Friend request accepted!")
    }
    
    
    //############################################################################################################################//
    
}



