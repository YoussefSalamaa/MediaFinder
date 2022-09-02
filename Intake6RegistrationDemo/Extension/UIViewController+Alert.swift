//
//  UIViewController+Alert.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 7/30/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Entery", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func startSearching(message: String) {
        let alert = UIAlertController(title: "Welcome to our app. 😍", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func continueSearching(message: String) {
        let alert = UIAlertController(title: "Didn't find what you need? 🤔", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Find it, play it!", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
