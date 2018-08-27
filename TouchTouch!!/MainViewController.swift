//
//  ViewController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/07/03.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    var username = ""

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //後ほどURLからダウンロード
        imageView.image = #imageLiteral(resourceName: "pic5")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100 / 2
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //後ほどFirebaseから取ってくる
        label.text = "米田"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 2
        return label
    }()
    
    func retriveUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userDB = Database.database().reference().child("users")
        userDB.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let snapShotValue = snapshot.value as? [String: Any] ?? ["": ""]
            self.username = snapShotValue["username"] as? String ?? ""
            let profileImageUrl = snapShotValue["profileImageUrl"] as? String ?? ""
    
            print(profileImageUrl)
        }
    }
    
    let highestLabel: UILabel = {
        let label = UILabel()
        label.text = "Highest Score"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        //後ほどFirebaseから取ってくる
        label.text = "50"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textAlignment = .center
        return label
    }()
    
    let startImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "start")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Start A New Game", for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleNext(){
        
        do{
           try Auth.auth().signOut()
        }catch{
            print("error")
        }
        
        let startTimerController = StartTimerController()
        self.present(startTimerController, animated: true, completion: nil)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        
        if Auth.auth().currentUser == nil{
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController,animated: true, completion: nil)
            }
        }
        
        retriveUser()
        print(username)
       
        let container = UIView()
//        container.layer.borderColor = UIColor.white.cgColor
//        container.layer.borderWidth = 0.5
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        container.heightAnchor.constraint(equalToConstant: 120).isActive = true

        container.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        container.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        view.addSubview(highestLabel)
        highestLabel.translatesAutoresizingMaskIntoConstraints = false
        highestLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 80).isActive = true
        highestLabel.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        highestLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: highestLabel.bottomAnchor, constant: 10).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        scoreLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
//        let container2 = UIView()
//        container2.backgroundColor = UIColor.white
//        view.addSubview(container2)
//        container2.translatesAutoresizingMaskIntoConstraints = false
//        container2.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 50).isActive = true
//        container2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        container2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        container2.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//
//        container2.addSubview(startImage)
//        startImage.translatesAutoresizingMaskIntoConstraints = false
//        startImage.centerYAnchor.constraint(equalTo: container2.centerYAnchor).isActive = true
//        startImage.leftAnchor.constraint(equalTo: container2.leftAnchor, constant: 10).isActive = true
//        startImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        startImage.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(startGameButton)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.backgroundColor = UIColor.white
        startGameButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 50).isActive = true
        startGameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        startGameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        startGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        startGameButton.addSubview(startImage)
        startImage.translatesAutoresizingMaskIntoConstraints = false
        startImage.centerYAnchor.constraint(equalTo: startGameButton.centerYAnchor).isActive = true
        startImage.leftAnchor.constraint(equalTo: startGameButton.leftAnchor, constant: 50).isActive = true
        startImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        startImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        

//        view.addSubview(profileImageView)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//
        
    }

    


}

