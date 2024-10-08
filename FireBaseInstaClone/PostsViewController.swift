//
//  PostsViewController.swift
//  FireBaseInstaClone
//
//  Created by Nurluay Sharifova on 06.10.24.
//

import UIKit
import FirebaseFirestoreInternal

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray = [QueryDocumentSnapshot]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        constraints()
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPost"), object: nil)

        
    }
    func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        
        
        
        return tableView
    }()
    @objc func getData () {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date",descending: true).addSnapshotListener { (snapshot,error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                  
                    self.dataArray = snapshot!.documents
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let postData = dataArray[indexPath.row].data()
        
        let comment = postData["postComment"] as? String ?? "No comment"
        let likes = postData["likes"] as? Int ?? 0
        let postedBy = postData["postedBy"] as? String ?? "Unknown"
        let imageUrl = postData["imageUrl"] as? String ?? ""
        
        
        cell.commentLabel.text = comment
        cell.likeCount.text = "\(likes)"
        cell.userEmailLabel.text = postedBy
        cell.documentId.text = dataArray[indexPath.row].documentID
        let url = URL(string:imageUrl)!
        if let data = try? Data(contentsOf: url) {
            cell.postImageView.image = UIImage(data: data)
            
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    func makeAlert(titleInput : String,messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
}
