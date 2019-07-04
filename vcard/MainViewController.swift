//
//  MainViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/4/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

protocol passUserDelegate: class {
    func passUser(id: String)
}

class MainViewController: UIViewController {
    
    var uid: String!
    
    var profileImageView: UIImageView!
    var nameTextView: UITextView!
    var emailTextView: UITextView!
    var phoneTextView: UITextView!
    var companyImageView: UIImageView!
    var jobTitleTextView: UITextView!
    var editButton: UIButton!
    var currentlyEditing: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VCard"
        view.backgroundColor = .white
        
        currentlyEditing = false
        
        profileImageView = UIImageView()
        nameTextView = UITextView()
        emailTextView = UITextView()
        phoneTextView = UITextView()
        companyImageView = UIImageView()
        jobTitleTextView = UITextView()
        editButton = UIButton()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneTextView.translatesAutoresizingMaskIntoConstraints = false
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        jobTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextView.isEditable = false
        emailTextView.isEditable = false
        phoneTextView.isEditable = false
        jobTitleTextView.isEditable = false
        
        nameTextView.text = "Name"
        emailTextView.text = "Email"
        phoneTextView.text = "Phone"
        jobTitleTextView.text = "Job Title"
        
        profileImageView.image = UIImage(named: "default")
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        companyImageView.image = UIImage(named: "company")
        companyImageView.clipsToBounds = true
        companyImageView.contentMode = .scaleAspectFit
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.addTarget(self, action: #selector(editOrSave), for: .touchUpInside)
        editButton.backgroundColor = .blue
        editButton.layer.cornerRadius = editButton.frame.width/2
        
        //Need to figure out how to round images and buttons
        //Figure out excact layout that I want to pursue
        //Will also have to set up a navigation bar/title, figure out
        //whether to use navigation or modal view controller
        
        nameTextView.textAlignment = .center
        emailTextView.textAlignment = .center
        phoneTextView.textAlignment = .center
        jobTitleTextView.textAlignment = .center
        
        view.addSubview(profileImageView)
        view.addSubview(nameTextView)
        view.addSubview(emailTextView)
        view.addSubview(phoneTextView)
        view.addSubview(companyImageView)
        view.addSubview(jobTitleTextView)
        view.addSubview(editButton)
        
        setupConstraints()
    }
    

    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: view.frame.width/3),
            profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width/3)
            ])
        NSLayoutConstraint.activate([
            nameTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            nameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameTextView.heightAnchor.constraint(equalToConstant: 32)
            ])
        NSLayoutConstraint.activate([
            emailTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 8),
            emailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailTextView.heightAnchor.constraint(equalToConstant: 24)
            ])
        NSLayoutConstraint.activate([
            phoneTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 8),
            phoneTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            phoneTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            phoneTextView.heightAnchor.constraint(equalToConstant: 24)
            ])
        NSLayoutConstraint.activate([
            companyImageView.topAnchor.constraint(equalTo: phoneTextView.bottomAnchor, constant: 32),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            companyImageView.widthAnchor.constraint(equalToConstant: view.frame.width/5),
            companyImageView.heightAnchor.constraint(equalToConstant: view.frame.width/5)
            ])
        NSLayoutConstraint.activate([
            jobTitleTextView.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 32),
            jobTitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            jobTitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            jobTitleTextView.heightAnchor.constraint(equalToConstant: 24)
            ])
        NSLayoutConstraint.activate([
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            editButton.widthAnchor.constraint(equalToConstant: 64),
            editButton.heightAnchor.constraint(equalToConstant: 64)
            ])
        
    }
    
    @objc func editOrSave() {
        if currentlyEditing {
            
        }
        else {
            
        }
    }

}

extension MainViewController: passUserDelegate {
    func passUser(id: String) {
        uid = id
        //Will eventually have to edit text fields and images here
        //Check if the database entry is true, if so keep default values
        //If not then get the data from Firebase and populate fields
    }
}
