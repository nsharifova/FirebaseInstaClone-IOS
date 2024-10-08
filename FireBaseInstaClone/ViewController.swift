//
//  ViewController.swift
//  FireBaseInstaClone
//
//  Created by Nurluay Sharifova on 04.10.24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        view.addSubview(textLabel)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            //            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.8),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.widthAnchor.constraint(equalToConstant: 100),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            
            
        ])
    }
    let emailField : UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.borderStyle = .roundedRect
        email.keyboardType = .emailAddress
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    let passwordField : UITextField = {
        let password = UITextField()
        password.borderStyle = .roundedRect
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    let textLabel : UILabel = {
        let text = UILabel()
        text.text = "Instagram clone"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let signInButton : UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.backgroundColor = .blue
        btn.setTitle("Sign in", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        return btn
    }()
    let signUpButton : UIButton = {
        let signUp = UIButton()
        signUp.tintColor = .white
        signUp.backgroundColor = .blue
        signUp.setTitle("Sign up", for: .normal)
        signUp.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        return signUp
    }()
    
    @objc func signInAction() {
   
        if (emailField.text != "" && passwordField.text != "") {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
                (authdata,error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                    let controller = self.storyboard?.instantiateViewController(identifier: "tabController") as! UITabBarController
                    self.navigationController?.show(controller, sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Please fill the fields")
        }
        
    }
    @objc func signUpAction () {
        if (emailField.text != "" && passwordField.text != "") {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                (authdata,error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                    let controller = self.storyboard?.instantiateViewController(identifier: "tabController") as! UITabBarController
                    self.navigationController?.show(controller, sender: nil)
                }
            }
            
        }
        else {
            self.makeAlert(titleInput: "Error", messageInput: "Please fill the fields")
        }
        
    }
    func makeAlert(titleInput : String,messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
    
}

