//
//  MessagesViewCell.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/24/23.
//

import Foundation
import UIKit

class MessagesViewCell: UITableViewCell {
    let mainTextLabel = UILabel()
    let secondaryTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextLabel.font = UIFont.systemFont(ofSize: 10)
        
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(secondaryTextLabel)
        
        NSLayoutConstraint.activate([
            mainTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            mainTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainTextLabel.heightAnchor.constraint(equalToConstant: 60),
            
            secondaryTextLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            secondaryTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with mainText: String, detailText: String) {
        mainTextLabel.text = mainText
        secondaryTextLabel.text = detailText
    }
}
