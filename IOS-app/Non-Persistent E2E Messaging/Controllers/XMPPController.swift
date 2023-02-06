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
    
    //Allows for global use of the XMPP Controller throughout the projects views
    static let shared = XMPPController()
    private override init(){}
    
    var xmppStream = XMPPStream()
    let hostName = "52.188.65.46"
    let hostPort = 5222
    var userJID = ""
    var password = ""
    
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
    
//############################################################################################################################//
    
    func disconnectStream() {
        if xmppStream.isConnected {
            xmppStream.disconnect()
            print("Disconnecting from XMPP Server...")
        }
    }
    
//############################################################################################################################//
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
        print("Disconnected from XMPP Server")
    }
    
//############################################################################################################################//

    //Function to start authentication after connecting
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        if xmppStream.isAuthenticating{
            print("Attempted to authenticate twice.")
        }
        else{
            print("Connected to XMPP server")
            authenticate()
        }
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
    }
    
//############################################################################################################################//
    
    //If Stream is unable to Authenticate, message sends to console
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("Error authenticating with XMPP server: \(error)")
    }
    
//############################################################################################################################//
    
    //Funtion to send a message
    
    func sendMessage(message: String, recipient: String) {
        let messageElement = XMPPMessage(type: "chat", to: XMPPJID(string: recipient))
        messageElement.addBody(message)
        self.xmppStream.send(messageElement)
        print("Sent")
    }
}



