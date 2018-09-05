//
//  Utils.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/08/31.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    static func fetchUsernameScoreUrl(uid: String, completion: @escaping(Users)->()){
        Database.database().reference().child("scores").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
                let snapshotValue = snapshot.value as? Dictionary<String, Any> ?? ["":""]
                let score = "\(snapshotValue["score"] as? Int ?? 0)"
                let username = snapshotValue["username"] as? String ?? ""
                let profileImageUrl = snapshotValue["profileImageUrl"] as? String ?? ""
            
            let users = Users()
//            users.score = String(score)
            users.userName = username
            users.profileImageUrl = profileImageUrl
            completion(users)
    }
    }
    
}
