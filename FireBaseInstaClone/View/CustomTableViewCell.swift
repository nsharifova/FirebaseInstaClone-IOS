import UIKit
import FirebaseFirestoreInternal

class CustomTableViewCell: UITableViewCell {
    var postLikeCount : Int = 0
    let userEmailLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let documentId: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let likeCount: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Like", for: .normal)
        button.addTarget(self, action: #selector(likeAction), for:  .touchUpInside)
        return button
    }()

    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    @objc func likeAction () {
        let fireStoreDatabase = Firestore.firestore()
        if let like = Int(likeCount.text!) {
            let likeStore = ["likes" : like + 1] as [String : Any]
            fireStoreDatabase.collection("Posts").document(documentId.text!).setData(likeStore,merge: true)
            NotificationCenter.default.post(name: NSNotification.Name("newPost"), object: nil)

        }
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userEmailLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(likeCount)
        contentView.addSubview(likeButton)
        contentView.addSubview(postImageView)

    
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }

    func setConstraints() {
        
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userEmailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userEmailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userEmailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            postImageView.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 10),
            postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            commentLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            likeButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            likeCount.centerYAnchor.constraint(equalTo:likeButton.centerYAnchor),
            likeCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
        ])
    }
}
