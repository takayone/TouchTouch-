//
//  StageResultController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/09/05.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class StageResultController: UIViewController{
    
    var usersArray = [Users]()
    var stageResult: String = ""
    
    var userProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pic7")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 100 / 2
        return iv
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        return label
    }()
    
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backToGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Back To Game", for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleBackToGame), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBackToGame(){
        let mainViewController = MainViewController()
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        resultLabel.text = stageResult
        userNameProfileUrlRetrieve()
        setUpViews()
    }
    
    
    fileprivate func setUpViews(){
        
        view.addSubview(userProfileImageView)
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userProfileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: userProfileImageView.rightAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 80).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        resultLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        view.addSubview(backToGameButton)
        backToGameButton.translatesAutoresizingMaskIntoConstraints = false
        backToGameButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 10).isActive = true
        backToGameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        backToGameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        backToGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backToGameButton.addSubview(backImage)
        backImage.translatesAutoresizingMaskIntoConstraints = false
        backImage.centerYAnchor.constraint(equalTo: backToGameButton.centerYAnchor).isActive = true
        backImage.leftAnchor.constraint(equalTo: backToGameButton.leftAnchor, constant: 30).isActive = true
        backImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func userNameProfileUrlRetrieve(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userDB = Database.database().reference().child("users")
        userDB.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as? Dictionary<String, Any> ?? ["":""]
    
            self.usernameLabel.text = snapshotValue["username"] as? String ?? ""
            let profileImageUrl = snapshotValue["profileImageUrl"] as? String ?? ""
        
            guard let url = URL(string: profileImageUrl) else {return}
            self.userProfileImageView.sd_setImage(with: url, completed: nil)
        }
        
    }
    
    
}
