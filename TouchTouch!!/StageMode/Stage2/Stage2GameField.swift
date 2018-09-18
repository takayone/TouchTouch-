//
//  Stage2GameField.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/09/05.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class Stage2GameField: UIViewController{
    
    var countDownTimer = Timer()
    var remainedTime : Int = 3
    var countNumbers : Int = 0
    var highestScore: Int = 0
    var username : String = ""
    var profileImageUrl: String = ""
    
    let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let remainedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    let timerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "timer"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let missionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = "Mission \n 20 Touches!!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
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
        
        setUpViews()
    }
    
    fileprivate func setUpViews(){
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
        
        view.addSubview(missionLabel)
        missionLabel.translatesAutoresizingMaskIntoConstraints = false
        missionLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 30).isActive = true
        missionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        missionLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        missionLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
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
    
    @objc func handleProgressTimer(){
        
        remainedTime -= 1
        remainedTimeLabel.text = "\(remainedTime)"
        
        if remainedTime < 4{
            remainedTimeLabel.textColor = UIColor.red
            progressBar.backgroundColor = UIColor.red
        }
        
        if remainedTime < 1{
            countDownTimer.invalidate()
            
            if countNumbers > 19{
                let stage3StartController = Stage3StartController()
                present(stage3StartController, animated: true, completion: nil)
            }else{
                let stageResultController = StageResultController()
                stageResultController.stageResult = "Stage1 Clear"
                present(stageResultController, animated: true, completion: nil)
                
            }
            
        }
        
    }
}
