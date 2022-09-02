//
//  userDefaultsManager.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/4/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import Foundation

class UserDefaultsManager{
    
    // MARK:- Singleton
    private static let sharedInstance = UserDefaultsManager()
    
    class func shared() -> UserDefaultsManager {
        return UserDefaultsManager.sharedInstance
    }
    
    private let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        set {
            defaults.setValue(newValue, forKeyPath: "isLoggedIn")
        } get {
            guard defaults.object(forKey: "isLoggedIn") != nil else {
                return false
            }
            return defaults.bool(forKey: "isLoggedIn")
        }
    }
    var email: String {
        set {
            defaults.setValue(newValue, forKeyPath: "email")

        } get {
            guard  defaults.object(forKey: "email") != nil else {
                return "No email found in user defaults"
            }
            return defaults.string(forKey: "email")!
        }
    }
}
