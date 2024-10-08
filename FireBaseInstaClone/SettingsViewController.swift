//
//  SettingsViewController.swift
//  FireBaseInstaClone
//
//  Created by Nurluay Sharifova on 06.10.24.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])

    }
    
    private let logoutButton : UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.tintColor = .blue
        button.backgroundColor = .lightGray
        button.layer.borderColor = CGColor(gray: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return button
        
    }()
    
    @objc func logoutAction () {

        do {
            try Auth.auth().signOut()
            let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController?.show(controller, sender: nil)
        } catch {
            print ("Error")
        }
    }

    

}
