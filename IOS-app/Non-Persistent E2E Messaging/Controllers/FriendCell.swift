//
//  FriendCell.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/7/23.
//

import Foundation
import UIKit
import SwiftUI

class FriendCell: UITableViewCell{
    
    //############################################################################################################################//
    //#                                                 Cell Configuration                                                       #//
    //############################################################################################################################//
    
    //var profilePic = UIImageView()
    var name = UILabel()
    var presenceIndicator = CircleView()
    
    //###################################################################################//
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(profilePic)
        addSubview(name)
        addSubview(presenceIndicator)
        configureLabel()
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
        //name.numberOfLines = 0
        name.adjustsFontSizeToFitWidth = true
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
        presenceIndicator.translatesAutoresizingMaskIntoConstraints = false
        presenceIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
        presenceIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        presenceIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        presenceIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
    }
}

//############################################################################################################################//
//#                                                     Circle Class                                                         #//
//############################################################################################################################//

//Creates a circle for the UI

class CircleView: UIView {
    
    //###################################################################################//
    
    var circleColor: UIColor = .red {
            didSet {
                setNeedsDisplay()
            }
        }
    
    //###################################################################################//
    
    override func draw(_ rect: CGRect) {
        let radius = 50
        let circleRect = CGRect(x: Int(rect.midX) - radius, y: Int(rect.midY) - radius, width: radius * 2, height: radius * 2)
        let path = UIBezierPath(ovalIn: circleRect)
        circleColor.setFill()
        path.fill()
    }
}

//############################################################################################################################//



