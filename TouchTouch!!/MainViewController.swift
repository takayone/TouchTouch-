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
    

//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        //後ほどURLからダウンロード
//        imageView.image = #imageLiteral(resourceName: "pic5")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 100 / 2
//        return imageView
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        //後ほどFirebaseから取ってくる
//        label.text = "米田"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 30)
//        label.numberOfLines = 2
//        return label
//    }()
//
//    func retriveUser(){
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let userDB = Database.database().reference().child("users")
//        userDB.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//
//            let snapShotValue = snapshot.value as? [String: Any] ?? ["": ""]
//            self.username = snapShotValue["username"] as? String ?? ""
//            let profileImageUrl = snapShotValue["profileImageUrl"] as? String ?? ""
//
//            print(profileImageUrl)
//        }
//    }
//
//    let highestLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Highest Score"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 30)
//        label.textAlignment = .center
//        return label
//    }()
//
//    let scoreLabel: UILabel = {
//        let label = UILabel()
//        //後ほどFirebaseから取ってくる
//        label.text = "50"
//        label.textColor = UIColor.white
//        label.font = UIFont.boldSystemFont(ofSize: 100)
//        label.textAlignment = .center
//        return label
//    }()
    
    let touchButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "touchButton").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
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

        let startTimerController = StartTimerController()
        self.present(startTimerController, animated: true, completion: nil)
    }
    
    let logoutImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logout").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleLogout(){
        do
        {
            try Auth.auth().signOut()
            
        }catch{
            print("error")
        }
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController,animated: true, completion: nil)
        }
        
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
        
        view.addSubview(touchButtonImage)
        touchButtonImage.translatesAutoresizingMaskIntoConstraints = false
        touchButtonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        touchButtonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        touchButtonImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        touchButtonImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        

        view.addSubview(startGameButton)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.backgroundColor = UIColor.white
        startGameButton.topAnchor.constraint(equalTo: touchButtonImage.bottomAnchor, constant: 100).isActive = true
        startGameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        startGameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        startGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        startGameButton.addSubview(startImage)
        startImage.translatesAutoresizingMaskIntoConstraints = false
        startImage.centerYAnchor.constraint(equalTo: startGameButton.centerYAnchor).isActive = true
        startImage.leftAnchor.constraint(equalTo: startGameButton.leftAnchor, constant: 30).isActive = true
        startImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        startImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = UIColor.white
        logoutButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: 50).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logoutButton.addSubview(logoutImage)
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        logoutImage.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor).isActive = true
        logoutImage.leftAnchor.constraint(equalTo: logoutButton.leftAnchor, constant: 30).isActive = true
        logoutImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoutImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

    


}

