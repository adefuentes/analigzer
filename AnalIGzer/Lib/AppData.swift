//
//  AppData.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 17/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

struct IGSavedData {
    
    public static var userID: String? {
        get {
            return UserDefaults.standard.value(forKey: "userID") as? String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    public static var username: String? {
        get {
            return UserDefaults.standard.value(forKey: "username") as? String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    public static var cookies: String {
        get {
            return UserDefaults.standard.value(forKey: "cookies") as? String ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "cookies")
        }
    }
}
