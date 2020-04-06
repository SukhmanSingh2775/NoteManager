//
//  VerifyViewController.swift
//  Connectivity
//
//  Created by Sukhman Singh on 3/31/20.
//  Copyright © 2020 Sukhman Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class VerifyViewController: UIViewController {
    
    @IBOutlet var instructLbl: UILabel!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleHollowButton(verifyBtn)
        
    }

    @IBAction func verifyBtnPressed(_ sender: Any)
    {
        
        Auth.auth().currentUser?.reload(completion: { (err) in
                if err != nil{
                    print("Err reloading the user")
                }
                else{
                    print("Succes reloading the user")
                }
            })
    
            _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                if  user?.isEmailVerified == true{
                    self.instructLbl.text = "Verified email"
                    self.transitionToHome()
                }

            }
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.HomeViewController) as? HomePageViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
