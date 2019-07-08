//
//  SideViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/6/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit
import FirebaseAuth

class SideViewController: UIViewController {
    
    var sideTableView: UITableView!
    let reuseIdentifier = "Side"
    var options: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        options = ["My Card", "My Code", "Scan Code", "Contacts", "Log Out"]
        
        sideTableView = UITableView()
        sideTableView.translatesAutoresizingMaskIntoConstraints = false
        sideTableView.dataSource = self
        sideTableView.delegate = self
        sideTableView.register(SideTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(sideTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            sideTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sideTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            sideTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sideTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}

extension SideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SideTableViewCell
        let option = options[indexPath.row]
        cell.configure(option: option)
        return cell
    }
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension SideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = sideTableView.cellForRow(at: indexPath) as! SideTableViewCell
        let top = topMostController()
        let qrViewController = QRViewController()
        let mainViewController = MainViewController()
        let authViewController = AuthenticationViewController()
        let contactsViewController = ContactsViewController()
        let scanViewController = ScanViewController()
        
        if cell.textView.text == "My Card" {
            top.present(mainViewController, animated: true, completion: nil)
        }
        else if cell.textView.text == "My Code" {
            top.present(qrViewController, animated: true, completion: nil)
        }
        else if cell.textView.text == "Scan Code" {
            top.present(scanViewController, animated: true, completion: nil)
        }
        else if cell.textView.text == "Contacts" {
            top.present(contactsViewController, animated: true, completion: nil)
        }
        else if cell.textView.text == "Log Out" {
            signOut()
            top.present(authViewController, animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
