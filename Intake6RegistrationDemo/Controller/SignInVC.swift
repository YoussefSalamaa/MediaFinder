//
//  SignInVC.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 6/23/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import SQLite

class SignInVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK:- Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:-Actions
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        registerButtonTapped()
    }
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        loginButtonTapped()
    }
}

// MARK:- Private Methods
extension SignInVC {
    private func registerButtonTapped(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(vc, animated: true)
    }
    private func goToMediaVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MediaVC") as! MediaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Setup UI
extension SignInVC {
    private func setupUI() {
        self.navigationItem.title = "Sign In"
        self.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesBackButton = true
        UserDefaultsManager.shared().isLoggedIn = false
    }
}

//MARK:- Data Funcations
extension SignInVC {
    func dataEntered () -> Bool {
        guard let email = emailTextField.text, email != "" else {
            showAlert(message: " please Enter email")
            return false
        }
        guard let password = passwordTextField.text, password != "" else {
            showAlert(message: " please Enter password")
            return false
        }
        return true
    }
    
    //MARK:- Data validation func.
    private func dataValid() -> Bool {
        guard isValidEmail(email: emailTextField.text!) else{
            self.showAlert(message: "please enter a valid email example ys@gmail.com")
            return false
        }
        guard isValidPassword(password: passwordTextField.text!) else {
            self.showAlert(message: "please enter a valid password")
            return false
        }
        return true
    }
    
    //MARK:- Regex.
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailpredict = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailpredict.evaluate(with: email)
    }
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordpredict = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordpredict.evaluate(with: password)
    }
    
    //MARK:- Data matching func.
    func matchingData(email: String, password: String) -> Bool {
        guard (email == emailTextField.text) else {
            self.showAlert(message: "wrong email entered")
            return false
        }
        guard (password == passwordTextField.text) else {
            self.showAlert(message: "wrong password entered")
            return false
        }
        return true
    }
    
    //MARK:- Login Button Funcations.
    func loginButtonTapped(){
        if dataEntered() {
            if dataValid() {
                if let user = SQlManager.sharedObject().getUserData(email: emailTextField.text!) {
                    if matchingData(email: emailTextField.text!, password: user.password) {
                        UserDefaultsManager.shared().email = emailTextField.text!
                        goToMediaVC()                        
                    }
                }
            }
        } 
    }
}
