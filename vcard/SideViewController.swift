//
//  SideViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/6/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    
    var sideTableView: UITableView!
    let reuseIdentifier = "Side"
    var options: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        options = ["My card", "My code", "Scan Code", "Contacts", "Log Out"]
        
        sideTableView = UITableView()
        sideTableView.translatesAutoresizingMaskIntoConstraints = false
        sideTableView.dataSource = self
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension SideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
