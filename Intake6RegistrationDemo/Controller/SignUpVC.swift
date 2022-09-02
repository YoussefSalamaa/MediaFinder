//
//  SignUpVC.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 6/23/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import SQLite

class SignUpVC: UIViewController {
    
    //MARK:- Outlets.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var userImagView: UIImageView!
    
    //MARK:- Vaiables.
    private var imagePicker = UIImagePickerController()
    
    //MARK:- Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        self.navigationItem.title = "SignUp"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK:- Actions
    @IBAction func RegisterButton(_ sender: UIButton) {
        signUpTapped()
    }
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        goToMapVC()
    }
    @IBAction func userImageButton(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK:- SendAddress
extension SignUpVC: SendAddress {
    func sendDetailedAddress(address: String) {
        addressTextField.text = address
    }
}

// MARK:- Image picker func.
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImagView.contentMode = .scaleAspectFill
            userImagView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Navigations.
extension SignUpVC {
    private func goToMapVC(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapVc = storyBoard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        mapVc.addressDelegate = self
        navigationController?.pushViewController(mapVc, animated: true)
    }
    private func goToLoginVC(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Data Entered Check func.
    private func dataEntered() -> Bool {
        guard let name = nameTextField.text, name != "" else {
            self.showAlert(message: "please enter name.")
            return false
        }
        guard let email = emailTextField.text, email != "" else {
            self.showAlert(message: "please enter email")
            return false
        }
        guard let password = passwordTextField.text, password != "" else {
            self.showAlert(message: "please enter password")
            return false
        }
        guard let address = addressTextField.text, address != "" else {
            self.showAlert(message: "please enter address")
            return false
        }
        guard let phone = phoneTextField.text, phone != "" else {
            self.showAlert(message: "please enter phone")
            return false
        }
        return true
    }
    
    //MARK:- Data Validation func.
    private func dataValid() -> Bool {
        guard isValidEmail(email: emailTextField.text!) else{
            self.showAlert(message: "please enter a valid email example ys@gmail.com")
            return false
        }
        guard isValidPassword(password: passwordTextField.text!) else {
            self.showAlert(message: "please enter a valid password")
            return false
        }
        guard isValidPhone(phone: phoneTextField.text!) else {
            self.showAlert(message: "please enter a valid number, exapmle: 01000000000")
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
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{11}$"
        let phonepredict = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonepredict.evaluate(with: phone)
    }
    
    //MARK:- Encode user Data
    func encodeUserToData(user: User) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            return data

        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    //MARK:- Sign in tapped func.
    private func signUpTapped() {
        if dataEntered(){
            if dataValid() {
                let user = User(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, phone: phoneTextField.text!, address: addressTextField.text!, userImage: CodableImage(withImage: userImagView.image!))
                if let userData = encodeUserToData(user: user) {
                    SQlManager.sharedObject().insertUser(user: userData)
                    goToLoginVC()
                }
            }
        }
    }
}
