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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VCard"
        view.backgroundColor = .white
        

        // Do any additional setup after loading the view.
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

extension MainViewController: passUserDelegate {
    func passUser(id: String) {
        uid = id
        
    }
}
