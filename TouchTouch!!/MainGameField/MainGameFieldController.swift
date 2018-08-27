//
//  MainGameFieldController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/07/11.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MainGameFieldController: UIViewController{
    
    var countDownTimer = Timer()
    var remainedTime : Int = 10
    var countNumbers : Int = 0
    var highestScore: Int = 0
    
    let scoreDB = Database.database().reference().child("scores")

    let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let remainedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()

    let timerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "timer"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textColor = UIColor.black
        label.text = "0"
        return label
    }()
    
    let touchesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "touchButton"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleTouchButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTouchButton(){
        countNumbers += 1
        scoreLabel.text = "\(countNumbers)"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleProgressTimer), userInfo: nil, repeats: true)
        
        scoreRetrieve()

        view.addSubview(timerImage)
        timerImage.translatesAutoresizingMaskIntoConstraints = false
        timerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        timerImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        timerImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timerImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(remainedTimeLabel)
        remainedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainedTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        remainedTimeLabel.leftAnchor.constraint(equalTo: timerImage.rightAnchor, constant: 20).isActive = true
        remainedTimeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        remainedTimeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.topAnchor.constraint(equalTo: timerImage.bottomAnchor).isActive = true
        progressBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        progressBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(touchesButton)
        touchesButton.translatesAutoresizingMaskIntoConstraints = false
        touchesButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30).isActive = true
        touchesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        touchesButton.heightAnchor.constraint(equalToConstant: 100).isActive = true

    }
    
    //MARK:- ProgressTimer
    @objc func handleProgressTimer(){
        
            remainedTime -= 1
            remainedTimeLabel.text = "\(remainedTime)"
//            progressBarUpdate()

            if remainedTime < 4{
                remainedTimeLabel.textColor = UIColor.red
                progressBar.backgroundColor = UIColor.red
            }

            if remainedTime < 1{
                countDownTimer.invalidate()
                if countNumbers > highestScore{
                  scoreSaved()
                }
                let resultViewController = ResultViewController()
                present(resultViewController, animated: true, completion: nil)
            }

    }
    
    func scoreRetrieve(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        scoreDB.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as? [String:Int]
            let score = snapshotValue!["score"] ?? 0
            self.highestScore = score
        }
    
    }
    
    func scoreSaved(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userDictionary = ["score": countNumbers]
        scoreDB.child(uid).updateChildValues(userDictionary)
    }

//    func progressBarUpdate(){
//        progressBar.frame.size.width = (view.frame.size.width / 10) * CGFloat(remainedTime)
//    }

    //MARK:- Handle Scores
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        countNumbers += 1
//        scoreLabel.text = "\(countNumbers)"
//
//    }
 
}
