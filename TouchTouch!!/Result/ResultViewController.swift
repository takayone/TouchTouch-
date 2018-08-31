//
//  ResultViewController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/08/20.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let cellId = "cellId"
    let tableView = UITableView()
    let scoreDB = Database.database().reference().child("scores")
    var usersArray = [Users]()
    
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
    
    let highestScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Highest Score"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        return label
    }()
    
    var scoreLabel: UILabel = {
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
        
        tableViewSetup()
        scoreUsernameRetrieve()
        userRankingretrieve()
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
        
        view.addSubview(highestScoreLabel)
        highestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highestScoreLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor).isActive = true
        highestScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        highestScoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: highestScoreLabel.bottomAnchor).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(backToGameButton)
        backToGameButton.translatesAutoresizingMaskIntoConstraints = false
        backToGameButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true
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
    
    func scoreUsernameRetrieve(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        scoreDB.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as? Dictionary<String, Any> ?? ["":""]
            self.scoreLabel.text = "\(snapshotValue["score"] as? Int ?? 0)"
            self.usernameLabel.text = snapshotValue["username"] as? String ?? ""
            let profileImageUrl = snapshotValue["profileImageUrl"] as? String ?? ""
            
            guard let url = URL(string: profileImageUrl) else {return}
            self.userProfileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func userRankingretrieve(){
        
        scoreDB.queryOrdered(byChild: "Scores").queryLimited(toLast: 10).observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as? Dictionary<String, Any> ?? ["":""]
            let score = snapshotValue["score"]
            let profileImageUrl = snapshotValue["profileImageUrl"]
            let username = snapshotValue["username"]
            
            let userDictionary = Users()
            userDictionary.score = score as? Int ?? 0
            userDictionary.userName = username as? String ?? ""
            userDictionary.profileImageUrl = profileImageUrl as? String ?? ""
            
            self.usersArray.append(userDictionary)
            self.usersArray.sort(by: {$0.score > $1.score})
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    fileprivate func tableViewSetup(){
        tableView.register(UINib(nibName: "RankingViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RankingViewCell
        cell.usernameLabel.text = usersArray[indexPath.row].userName
        cell.scoreLabel.text = String(usersArray[indexPath.row].score)
        
        let profileImageUrl = usersArray[indexPath.row].profileImageUrl
        let url = URL(string: profileImageUrl)
        cell.profileImageView.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
