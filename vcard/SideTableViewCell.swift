//
//  SideTableViewCell.swift
//  vcard
//
//  Created by Jordan Epstein on 7/6/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {
    
    var textView: UITextView!
    //var image: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont(name: "Arial", size: 17)
        contentView.addSubview(textView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(option: String) {
        textView.text = option
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
