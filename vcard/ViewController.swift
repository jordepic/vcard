//
//  ViewController.swift
//  vcard
//
//  Created by Jordan Epstein on 7/3/19.
//  Copyright © 2019 Jordan Epstein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var registerButton: UIButton!
    var loginButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    var errorLabel: UILabel!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        ref = Database.database().reference()
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "email"
        emailTextField.borderStyle = .roundedRect
        view.addSubview(emailTextField)
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "password"
        passwordTextField.borderStyle = .roundedRect
        view.addSubview(passwordTextField)
        
        registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = .lightGray
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        view.addSubview(registerButton)
        
        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .lightGray
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        view.addSubview(loginButton)
        
        errorLabel = UILabel()
        errorLabel.text = ""
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        view.addSubview(errorLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 32)
            ])
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 32)
            ])
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 128),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -128),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 128),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -128),
            registerButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // EVENTUALLY MAKE IT TO DETECT WHEN LOGGED IN AND SKIP SCREEN
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @objc func register () {
        if emailTextField.text != "", passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let user = authResult?.user {
                    self.ref.child("users/\(user.uid)").setValue(true)
                }
                if error != nil{
                    self.registerButton.backgroundColor = .lightGray
                    self.errorLabel.text = "Problem registering - user may already exist"
                }
                else {
                    self.registerButton.backgroundColor = .white
                    self.errorLabel.text = ""
                    //BRING UP NEW VIEW
                    print("Registered")
                }
            }
        }
        else {
            self.registerButton.backgroundColor = .lightGray
            self.errorLabel.text = "Please fill out username and password fields"
        }
    }
    
    @objc func signIn() {
        if emailTextField.text != "", passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
                guard self != nil else { return }
                
                if error != nil{
                    self!.loginButton.backgroundColor = .lightGray
                    self!.errorLabel.text = "Problem logging in - email or password may be incorrect"
                }
                else {
                    self!.registerButton.backgroundColor = .white
                    self!.errorLabel.text = ""
                    //Bring up New View
                    print("Logged In")
                }
            }
        }
        else {
            self.loginButton.backgroundColor = .lightGray
            self.errorLabel.text = "Please fill out username and password fields"
        }
    }
}

