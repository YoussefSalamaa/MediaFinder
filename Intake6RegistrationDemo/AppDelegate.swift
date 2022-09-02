//
//  AppDelegate.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 6/23/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        handleRoot()
        SQlManager.sharedObject().setupConnection()
        IQKeyboardManager.shared.enable = true
        return true
    }
}

extension AppDelegate {
    
    //MARK:- Switch to Login.
    func switchToSignInVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let nav2 = UINavigationController(rootViewController: vc2)
        window?.rootViewController = nav2
    }
    
    //MARK:- Switch to Media.
    func switchToMediaVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "MediaVC") as! MediaVC
        let nav1 = UINavigationController(rootViewController: vc1)
        window?.rootViewController = nav1
    }
    
    //MARK:- Navigation controller handeling.
    private func handleRoot() {
        let user = UserDefaults.standard.object(forKey: "email")
        let isLoggedIn = UserDefaultsManager.shared().isLoggedIn
        if user != nil{
            if isLoggedIn == true {
                switchToMediaVC()
            } else {
                switchToSignInVC()
            }
        }
    }
}
