//
//  WelcomeViewController.swift
//  Connectivity
//
//  Created by Sukhman Singh on 3/30/20.
//  Copyright © 2020 Sukhman Singh. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var SignUpBtn: UIButton!
    
    @IBOutlet weak var LoginBtn: UIButton!
    
    let userDefaults = UserDefaults.standard
    
        override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        view.backgroundColor = UIColor.white
            
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        if userDefaults.bool(forKey: "isLoggedIn") == true
        {
            transitionToHome()
        }

    }
    
    func setUpElements()
    {
        Utilities.styleFilledButton(SignUpBtn)
        Utilities.styleHollowButton(LoginBtn)
    }
    
    @IBAction func SignUpBtnPressed(_ sender: UIButton){}
    @IBAction func LoginBtnPressed(_ sender: Any){}
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.HomeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
