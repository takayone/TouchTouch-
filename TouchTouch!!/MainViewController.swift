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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil{
            
            DispatchQueue.main.async {
//                let loginController = LoginController()
//                let navController = UINavigationController(rootViewController: loginController)
//                self.present(navController, animated: true, completion: nil)
                let signupController = SignUpController()
                let navController = UINavigationController(rootViewController: signupController)
                self.present(navController,animated: true, completion: nil)
            }
            return
        }
        
    }

    


}

