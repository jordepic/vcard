//
//  File.swift
//  vcard
//
//  Created by Jordan Epstein on 7/21/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Contact {
    var name: String
    var uid: String
    var ref: DatabaseReference!
    
    init(uid: String) {
        self.uid = uid
        ref = Database.database().reference()
        name = ""
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
            let value = snapshot.value as? NSDictionary
            self.name = (value?["Name"] as? String ?? "")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
