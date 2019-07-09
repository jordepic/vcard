//
//  QRViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/7/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit
import FirebaseAuth
import SideMenu

class QRViewController: UIViewController {
    
    var qr: UIImageView!
    var uid: String!
    var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "My Code"
        
        uid = Auth.auth().currentUser?.uid
        
        menuButton = UIBarButtonItem()
        menuButton.target = self
        menuButton.action = #selector(toggleMenu)
        //menuButton.image = UIImage(named: "menu")
        menuButton.title = "Menu"
        self.navigationItem.leftBarButtonItem = menuButton
        
        qr = UIImageView()
        qr.translatesAutoresizingMaskIntoConstraints = false
        if let image = generateQRCode(from: uid){
            qr.image = image
        }
        qr.clipsToBounds = true
        qr.contentMode = .scaleAspectFit
        view.addSubview(qr)
        
        setupConstraints()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            qr.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qr.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qr.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            qr.heightAnchor.constraint(equalToConstant: view.frame.width/2)
            ])
    }
    
    @objc func toggleMenu(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
