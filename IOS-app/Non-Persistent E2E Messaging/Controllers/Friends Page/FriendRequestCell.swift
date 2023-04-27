//
//  FriendRequestCell.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 4/19/23.
//

import Foundation
import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.lightGray.cgColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
   
        return view
    }()
    
    
    private func setupViews() {
        addSubview(titleLabel)
        contentView.addSubview(topBorder)
        contentView.addSubview(bottomBorder)
        
        let borderWidth: CGFloat = 1
        
        let topMargin: CGFloat = 14
        let leftMargin: CGFloat = 16
        let rightMargin: CGFloat = 50
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topMargin),
            
            topBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftMargin),
            topBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightMargin),
            topBorder.topAnchor.constraint(equalTo: contentView.topAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: borderWidth),
            
            bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftMargin),
            bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightMargin),
            bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: borderWidth)
        ])
    }
}


