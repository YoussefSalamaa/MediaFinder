//
//  ProfileVC.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 6/23/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController{
    
    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK:- Variables.
    private var user: User!
    
    //MARK:- Life Cycle.
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
    }
}

//MARK:- Setup UI.
extension ProfileVC {
    private func setupUI() {
        self.navigationItem.title = "Profile"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        // Logout Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutTapped))
        
        // Media Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Media", style: .plain, target: self, action: #selector(MediaTapped))
        
        getUserFromDB()
        setUpData()
        UserDefaultsManager.shared().isLoggedIn = true
    }
}

//MARK:- Buttons Funcations.
extension ProfileVC {
    @objc private func logOutTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        appDelegate.switchToSignInVC()
    }
    @objc private func MediaTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        appDelegate.switchToMediaVC()
    }
}

//MARK:- Get & Set data Funcations.
extension ProfileVC {
    private func getUserFromDB() {
        self.user = SQlManager.sharedObject().getUserData(email: UserDefaultsManager.shared().email)
    }
    private func setUpData(){
        nameLabel.text = user.name
        emailLabel.text = user.email
        addressLabel.text = user.address
        phoneLabel.text = user.phone
        userImageView.image = user.userImage.getImage()
    }
}
