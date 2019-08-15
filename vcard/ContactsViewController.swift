//
//  ContactsViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/7/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SideMenu

class ContactsViewController: UIViewController, UISearchBarDelegate {

    var uid: String!
    var menuButton: UIBarButtonItem!
    var searchTextField: UISearchBar!
    var contactsTableView: UITableView!
    var ref: DatabaseReference!
    var uidArray: [String]!
    var contacts: [Contact]!
    var modifiedContacts: [Contact]!
    var reuseIdentifier = "contact"
    weak var delegate: passContactDelegate?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Contacts"
        
        uidArray = []
        contacts = []
        
        uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        menuButton = UIBarButtonItem()
        menuButton.target = self
        menuButton.action = #selector(toggleMenu)
        //menuButton.image = UIImage(named: "menu")
        menuButton.title = "Menu"
        self.navigationItem.leftBarButtonItem = menuButton
        
        searchTextField = UISearchBar()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search"
        searchTextField.delegate = self
        searchTextField.returnKeyType = UIReturnKeyType.done
        view.addSubview(searchTextField)
        
        contactsTableView = UITableView()
        contactsTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contactsTableView)
        
        ref.child("contacts").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.uidArray = snapshot.value as? NSArray as? [String] ?? []
            for id in self.uidArray{
                self.contacts.append(Contact(uid: id))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contacts = self.contacts.sorted(by: { $0.name < $1.name })
        self.contactsTableView.reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            contactsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    @objc func toggleMenu(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isEditing = false
            view.endEditing(true)
            contactsTableView.reloadData()
        }else {
            isEditing = true
            modifiedContacts = contacts.filter({$0.name.contains(searchText)})
            contactsTableView.reloadData()
        }
    }
    
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditing {
            return modifiedContacts.count
        }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactTableViewCell
        let contact: Contact!
        if isEditing {
            contact = modifiedContacts[indexPath.row]
        }
        else {
            contact = contacts[indexPath.row]
        }
        cell.configure(contact: contact)
        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardViewController = OtherUserViewController()
        delegate = cardViewController
        let contact: Contact!
        if isEditing {
            contact = modifiedContacts[indexPath.row]
        }
        else {
            contact = contacts[indexPath.row]
        }
        delegate?.passContact(id: contact.uid)
        navigationController?.pushViewController(cardViewController, animated: true)
    }
}
