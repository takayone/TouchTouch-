//
//  StartTimerController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/07/11.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class StartTimerController: UIViewController{
    
    var timer = Timer()
    var countDownTime : Int = 4
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "pic1"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
      
        
    }
    
    @objc func updateTimer(){
        countDownTime -= 1
        countLabel.text = String(countDownTime)
        
        if countDownTime < 1{
            timer.invalidate()
            let mainGameFieldController = MainGameFieldController()
            present(mainGameFieldController, animated: true, completion: nil)
        }
    }
    
}
