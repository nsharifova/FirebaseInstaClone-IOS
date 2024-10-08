//
//  UploadViewController.swift
//  FireBaseInstaClone
//
//  Created by Nurluay Sharifova on 06.10.24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
    }
    private let textField : UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Comment"
        text.borderStyle = .roundedRect
        return text
    }()
    let saveButton : UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.backgroundColor = .blue
        btn.setTitle("Save", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        return btn
    }()
    @objc func saveAction () {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let uuid = UUID().uuidString
        let folder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = folder.child(uuid)
            imageReference.putData(data,metadata: nil) { (metadata,error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", message: error?.localizedDescription ?? "Error")
                }
                else {
                    imageReference.downloadURL{ (url,error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageUrl": imageUrl!,"postedBy" : Auth.auth().currentUser!.email,"postComment" : self.textField.text!,"date": FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost,completion: {(error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.textField.text = ""
                                    self.imageView.image = UIImage(named: "")
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
            
        }
    }
    @objc func choseImage () {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true,completion: nil)
    }
    func makeAlert (titleInput: String,message: String) {
        let alert = UIAlertController(title: titleInput, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
