//
//  OtherUserViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/21/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit

import Firebase
import FirebaseStorage
import FirebaseDatabase

protocol passContactDelegate: class {
    func passContact(id: String)
}

class OtherUserViewController: UIViewController {
    
    var uid: String!
    
    var profileImageView: UIImageView!
    var nameTextView: UITextView!
    var emailTextView: UITextView!
    var phoneTextView: UITextView!
    var companyImageView: UIImageView!
    var jobTitleTextView: UITextView!
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        ref = Database.database().reference()
        
        profileImageView = UIImageView()
        nameTextView = UITextView()
        emailTextView = UITextView()
        phoneTextView = UITextView()
        companyImageView = UIImageView()
        jobTitleTextView = UITextView()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        phoneTextView.translatesAutoresizingMaskIntoConstraints = false
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        jobTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextView.isEditable = false
        emailTextView.isEditable = false
        phoneTextView.isEditable = false
        jobTitleTextView.isEditable = false
        
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        
        companyImageView.clipsToBounds = true
        companyImageView.contentMode = .scaleAspectFit
        
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
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveInfo()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 88),
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
            companyImageView.topAnchor.constraint(equalTo: phoneTextView.bottomAnchor, constant: 88),
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
    }
    
    func retrieveInfo() {
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.nameTextView.text = (value?["Name"] as? String ?? "")
            self.emailTextView.text = (value?["Email"] as? String ?? "")
            self.jobTitleTextView.text = (value?["Job Description"] as? String ?? "")
            self.phoneTextView.text = (value?["Phone"] as? String ?? "")
        }) { (error) in
            print(error.localizedDescription)
        }
        let profileRef = storageRef.child("\(self.uid!)/profile.jpg")
        let companyRef = storageRef.child("\(self.uid!)/company.jpg")
        
        profileRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
        
        companyRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                self.companyImageView.image = UIImage(data: data!)
            }
        }
        
    }
    

}

extension OtherUserViewController: passContactDelegate {
    func passContact(id: String) {
        uid = id
    }
}
