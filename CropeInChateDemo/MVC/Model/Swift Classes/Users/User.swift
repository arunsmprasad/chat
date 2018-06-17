//
//  User.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/16/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var UserId: String
    var UserName: String
    
    init(id: String, name: String) {
        self.UserId = id
        self.UserName = name
    }
    
    class func getAllUsers(exceptID: String, completion: @escaping (User) -> Void) {
        
        Database.database().reference().child(USER).observe(.childAdded, with: { (snapshot) in
            
            let id = snapshot.key
            
            let aUserInfo = snapshot.value as! [String: Any]
            
            print(aUserInfo)
            
            if id != exceptID {
                
                let aUser = User.init(id: id , name: aUserInfo[KEY_USER_NAME] as! String)
                completion(aUser)
            }
        })
    }
}
