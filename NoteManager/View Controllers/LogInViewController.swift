//
//  LogInViewController.swift
//  Connectivity
//
//  Created by Sukhman Singh on 3/30/20.
//  Copyright © 2020 Sukhman Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        setUpElements()
    }
    
    func setUpElements(){
        
        errorLbl.alpha = 0
        
        Utilities.styleTextField(emailTxtField)
        
        Utilities.styleTextField(passwordTxtField)
        
        Utilities.styleFilledButton(loginBtn)
        
        Utilities.styleFilledButton(resetBtn)
    }
    

    
    @IBAction func loginBtnPressed(_ sender: Any)
    {
        signInUser()
    }
    
    func validateFields() -> String?{
             
        // Check if the fields are not empty
         
        if emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
         {
             return "Please check for empty fields"
         }

         return nil
    }

    @IBAction func resetPasswordPressed(_ sender: UIButton)
    {
        let email = emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields()
        
        Auth.auth().sendPasswordReset(withEmail: email!) { (err) in
            
            if error == nil{
                                
                if err == nil{
                                
                    self.ShowError("Sent the password reset email")
                }
                else{
                }
            }
            else{
                
                self.ShowError("Something went wrong. Please check your email")
            }
        }
    }
    
    func signInUser(){
        
        let email = emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let error = validateFields()
        
        if error != nil{
            ShowError("Error")
            
        }
        else{
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, err) in
                     
             if err != nil{
                 // Error
                self.ShowError(err!.localizedDescription)
                         
             }
             else{
                         
                 self.transitionToHome()
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
             }
             }
        }
    }
    
    func ShowError(_ message: String){
         errorLbl.text = message
         errorLbl.alpha = 1
     }
    
    func transitionToHome(){
       let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.HomeViewController) as? HomePageViewController
       view.window?.rootViewController = homeViewController
       view.window?.makeKeyAndVisible()
   }

}
