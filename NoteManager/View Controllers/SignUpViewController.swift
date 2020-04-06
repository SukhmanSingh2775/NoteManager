//
//  SignUpViewController.swift
//  Connectivity
//
//  Created by Sukhman Singh on 3/30/20.
//  Copyright © 2020 Sukhman Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxtField: UITextField!
    
    @IBOutlet weak var lastNameTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        setUpElements()        
    }
    
    func setUpElements(){
        
        errorLbl.alpha = 0
        
        Utilities.styleTextField(firstNameTxtField)
        
        Utilities.styleTextField(lastNameTxtField)
        
        Utilities.styleTextField(emailTxtField)
        
        Utilities.styleTextField(passwordTxtField)
        
        Utilities.styleFilledButton(signUpBtn)
    }
    
    func validateFields() -> String?{
        
        // Check if the fields are not empty
        
        if firstNameTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please check for empty fields"
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid((cleanedPassword)!) == false{
            return "Please make sure you have 8 characters and no irregular letters in your password"
        }
        
        return nil
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton)
    {
        let error = validateFields()
        
        if error != nil {
            // There is an error
            ShowError(error!)
        }
        
        else{
            // Create a cleaned version of the data
            
            let firstname = firstNameTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (result, err) in
                
                if err != nil{
                    // There was an error
                    
                    self.ShowError("Error Signing Up")
                }
                else{
                    
                    self.performSegue(withIdentifier: "SignupToVerify", sender: self)
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    // Send verification email
                    
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                        if err != nil{}
                        else {
                        }
                    })
                    // Saving first and last name to the database
                    
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname": firstname!, "lastname": lastname!, "uid": result!.user.uid]) { (err) in
                        if err != nil{
                            // Error
                        }
                    }
                    
                    db.collection("users")
                }
            }
        }
    
    }
    
    func ShowError(_ message: String){
        errorLbl.text = message
        errorLbl.alpha = 1
    }
        
}
