//
//  XMPPController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 1/30/23.
//

import Foundation
import XMPPFramework

class XMPPController: NSObject, XMPPStreamDelegate{
    
//############################################################################################################################//
    
    static let shared = XMPPController()
    
    var xmppStream = XMPPStream()
    let hostName = "52.188.65.46"
    let hostPort = 5222
    var userJID = "dylan@selfdestructim.com"
    var password = "password"
    
//############################################################################################################################//
    
    //Function to connect XMPP Stream
    
    func connect() {
        
        xmppStream.hostName = hostName
        xmppStream.hostPort = UInt16(hostPort)
        xmppStream.myJID = XMPPJID(string: userJID)
        
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
    
//############################################################################################################################//

    //Function to start authentication after connecting
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("Connected to XMPP server")
        authenticate()
    }
    
//############################################################################################################################//
        
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
    
//############################################################################################################################//
    
    //If Stream Authenticates, sends presence to server
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("Authenticated with XMPP server")
        
        // Send presence to the server to indicate that the user is online
        let presence = XMPPPresence()
        self.xmppStream.send(presence)
        
        //Testing for Message Sending
        let messageElement = XMPPMessage(type: "chat", to: XMPPJID(string: "mason@selfdestructim.com"))
        messageElement.addBody("Hello this is a test.")
        // self.xmppStream.send(messageElement)
    }
    
//############################################################################################################################//
    
    //If Stream is unable to Authenticate, message sends to console
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("Error authenticating with XMPP server: \(error)")
    }
    
//############################################################################################################################//
    
    //Funtion to send a message
    
    func sendMessage(message: String) {
        let messageElement = XMPPMessage(type: "chat", to: XMPPJID(string: "mason@selfdestructim.com"))
        messageElement.addBody(message)
        self.xmppStream.send(messageElement)
        print("Sent")
    }
}



