//
//  ContactTableViewCell.swift
//  vcard
//
//  Created by Jordan Epstein on 7/21/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    var nameTextView: UITextView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameTextView = UITextView()
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTextView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(contact: Contact){
        nameTextView.text = contact.name
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameTextView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
