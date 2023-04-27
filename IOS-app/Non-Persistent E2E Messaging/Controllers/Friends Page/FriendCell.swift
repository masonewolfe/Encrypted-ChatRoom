//
//  FriendCell.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/7/23.
//

import Foundation
import UIKit
import SwiftUI
import FontAwesome_swift

class FriendCell: UITableViewCell{
    
    //############################################################################################################################//
    //#                                                 Cell Configuration                                                       #//
    //############################################################################################################################//
    
    //var profilePic = UIImageView()
    var name = UILabel()
    var onlineIndicator = UILabel()
    
    //###################################################################################//
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(profilePic)
        addSubview(name)
        addSubview(onlineIndicator)
        configureLabel()
        configureOnlineStatus() 
        setLabelConstraints()
        setIndicatorConstraints()
    }
    
    //###################################################################################//
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //############################################################################################################################//
    //#                                                    Cell Elements                                                         #//
    //############################################################################################################################//
    
    func configureLabel(){
        name.textColor = .black
        name.font = UIFont(name: "Avenir Next", size: 20)
        name.adjustsFontSizeToFitWidth = true
    }
    
    func configureOnlineStatus() {
        onlineIndicator.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        onlineIndicator.text = String.fontAwesomeIcon(name: .signal)
        onlineIndicator.textColor = .red
    }
    
    //###################################################################################//
    
    func setLabelConstraints(){
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        name.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    //###################################################################################//
    
    func setIndicatorConstraints(){
        
        onlineIndicator.translatesAutoresizingMaskIntoConstraints = false
        onlineIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        onlineIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        
    }
}



