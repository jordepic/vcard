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
import FirebaseAuth
import SideMenu

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
    var editButton: UIBarButtonItem!
    var menuButton: UIBarButtonItem!
    var currentlyEditing = false
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Card"
        view.backgroundColor = .white
        
        ref = Database.database().reference()
        
        profileImageView = UIImageView()
        nameTextView = UITextView()
        emailTextView = UITextView()
        phoneTextView = UITextView()
        companyImageView = UIImageView()
        jobTitleTextView = UITextView()
        editButton = UIBarButtonItem()
        menuButton = UIBarButtonItem()

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
        
        nameTextView.text = "Name"
        emailTextView.text = "Email"
        phoneTextView.text = "Phone"
        jobTitleTextView.text = "Job Title"
        
        profileImageView.image = UIImage(named: "default")
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        //profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        companyImageView.image = UIImage(named: "company")
        companyImageView.clipsToBounds = true
        companyImageView.contentMode = .scaleAspectFit
        
        //Need to figure out how to round images and buttons
        //Figure out excact layout that I want to pursue
        //Will also have to set up a navigation bar/title, figure out
        //whether to use navigation or modal view controller
        
        editButton.title = "Edit"
        editButton.target = self
        editButton.action = #selector(editOrSave)
        editButton.style = .plain
        self.navigationItem.rightBarButtonItem = editButton
        
        menuButton.target = self
        menuButton.action = #selector(toggleMenu)
        //menuButton.image = UIImage(named: "menu")
        menuButton.title = "Menu"
        self.navigationItem.leftBarButtonItem = menuButton
        
        nameTextView.textAlignment = .center
        emailTextView.textAlignment = .center
        phoneTextView.textAlignment = .center
        jobTitleTextView.textAlignment = .center
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        
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
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.uid = user.uid
                print("will appear")
                self.retrieveInfo()
            }
            else {
                let authenticationViewController = AuthenticationViewController()
                self.present(authenticationViewController, animated: true, completion: nil)
            }
        }
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
    }
    
    @objc func toggleMenu(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func editOrSave() {
        currentlyEditing.toggle()
        if editButton.title == "Edit"{
            editButton.title = "Save"
        }
        else {
            editButton.title = "Edit"
            jobTitleTextView.isEditable = false
            nameTextView.isEditable = false
            emailTextView.isEditable = false
            phoneTextView.isEditable = false
        }
        if currentlyEditing {
            jobTitleTextView.isEditable = true
            nameTextView.isEditable = true
            emailTextView.isEditable = true
            phoneTextView.isEditable = true
        }
        else {
            self.ref.child("users/\(uid!)").setValue(["Name": nameTextView.text, "Email": emailTextView.text, "Phone": phoneTextView.text, "Job Description": jobTitleTextView.text])
            retrieveInfo()
        }
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
