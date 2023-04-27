//
//  MessageBubbleCell.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/23/23.
//

import Foundation
import SwiftUI

class MessageBubbleCell: UITableViewCell {
    
    let senderMessageBubbleView = UIView()
    let senderMessageLabel = UILabel()
    
    let recipientMessageBubbleView = UIView()
    let recipientMessageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        senderMessageBubbleView.layer.cornerRadius = 10
        senderMessageBubbleView.backgroundColor = UIColor.lightGray
        addSubview(senderMessageBubbleView)
        
        senderMessageLabel.textColor = UIColor.white
        senderMessageLabel.numberOfLines = 0
        senderMessageBubbleView.addSubview(senderMessageLabel)
        
        recipientMessageBubbleView.layer.cornerRadius = 10
        recipientMessageBubbleView.backgroundColor = UIColor.black
        addSubview(recipientMessageBubbleView)
        
        recipientMessageLabel.textColor = UIColor.white
        recipientMessageLabel.numberOfLines = 0
        recipientMessageBubbleView.addSubview(recipientMessageLabel)
    }
    
    private func setupConstraints() {
        senderMessageBubbleView.translatesAutoresizingMaskIntoConstraints = false
        senderMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        recipientMessageBubbleView.translatesAutoresizingMaskIntoConstraints = false
        recipientMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            senderMessageBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            senderMessageBubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            senderMessageBubbleView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.7),
            senderMessageBubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            senderMessageLabel.leadingAnchor.constraint(equalTo: senderMessageBubbleView.leadingAnchor, constant: 10),
            senderMessageLabel.trailingAnchor.constraint(equalTo: senderMessageBubbleView.trailingAnchor, constant: -10),
            senderMessageLabel.topAnchor.constraint(equalTo: senderMessageBubbleView.topAnchor, constant: 5),
            senderMessageLabel.bottomAnchor.constraint(equalTo: senderMessageBubbleView.bottomAnchor, constant: -5),
            
            recipientMessageBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            recipientMessageBubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            recipientMessageBubbleView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.7),
            recipientMessageBubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            recipientMessageLabel.leadingAnchor.constraint(equalTo: recipientMessageBubbleView.leadingAnchor, constant: 10),
            recipientMessageLabel.trailingAnchor.constraint(equalTo: recipientMessageBubbleView.trailingAnchor, constant: -10),
            recipientMessageLabel.topAnchor.constraint(equalTo: recipientMessageBubbleView.topAnchor, constant: 5),
            recipientMessageLabel.bottomAnchor.constraint(equalTo: recipientMessageBubbleView.bottomAnchor, constant: -5),
        ])
    }
}
