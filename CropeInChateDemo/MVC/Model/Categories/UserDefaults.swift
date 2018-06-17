//
//  Session.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/16/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    //To Save Login Status
    func isLoggedIn(aBool: Bool) {
        
        UserDefaults.standard.set(aBool, forKey: IS_LOGGED_IN)
        saveSessionValues()
    }

    func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: IS_LOGGED_IN)
    }
    
    // To save and get the current user
    func setCurrentUserInfo(aUserInfo: [String: Any]) {
   
        UserDefaults.standard.set(aUserInfo, forKey: USER)
        saveSessionValues()
    }
    func getCurrentUserInfo() -> [String: Any] {
        
        let aDictionary = UserDefaults.standard.object(forKey: USER)
        
        if aDictionary != nil {
            return aDictionary as! [String : Any]
        }
        return [String : Any]()
    }
    
    func saveSessionValues() {
        
        UserDefaults.standard.synchronize()
    }
    
    func removeAllData() {
        
        let userInfo = [String: Any]()
        setCurrentUserInfo(aUserInfo: userInfo)
        isLoggedIn(aBool: false)
    }
    
}
