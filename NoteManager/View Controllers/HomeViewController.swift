//
//  HomeViewController.swift
//  NoteManager
//
//  Created by Sukhman Singh on 4/6/20.
//  Copyright © 2020 Sukhman Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseAnalytics

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addBtnImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let database = Firestore.firestore()
    
    let userDefaults = UserDefaults.standard
    
    var tasksArray = [String]()
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        addBtnSetup()
        tableViewSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        retrieveData()
    }
    
    func retrieveData()
    {
        if let currentUser = Auth.auth().currentUser
        {
            database.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, err) in
               if err == nil
               {

                     for document in (snapshot?.documents)!
                     {
       
                       if let tasks = document.data()["userTasks"] as? [String]
                         {
                           
                               for data in tasks
                               {
                                  
                                   
                                   
                                   if self.tasksArray.contains(data)
                                   {}
                                   else
                                   {
                                       self.tasksArray.append(data)
                                       self.tableView.reloadData()
                                   }
                               }
                          
                         }
                     }
                                     }
                     else
                     {
                         print("Error getting data")
                     }
           }
        }
       
    }
    
    
    
    func addBtnSetup()
    {
        addBtnImageView.isUserInteractionEnabled = true        
        addBtnImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addBtnPressed)))
    }
    
    @objc func addBtnPressed()
    {
        showAlert()
    }
    
    func showAlert()
    {
        var txtField = UITextField()
        
        let alert = UIAlertController(title: "Add data", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addBtn = UIAlertAction(title: "Add", style: .default) { (btn) in
            if txtField.text != ""
            {
                self.addDataToDatabase(txtField.text!)
                self.retrieveData()
            }
            else
            {
                print("Error adding data to the database. Txt Field was empty")
            }
            
            
        }
        
        alert.addTextField { (alertTxtField) in
            txtField = alertTxtField
            txtField.placeholder = "Type in the task here"
        }
        
        alert.addAction(cancel)
        alert.addAction(addBtn)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addDataToDatabase(_ text: String)
    {

        
        let profileDocument = database.collection("users").document(Auth.auth().currentUser!.uid)
                
        profileDocument.setData(["userTasks": FieldValue.arrayUnion([text])], merge: true)
        
 
    }
    
    func tableViewSetup()
    {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = tasksArray[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell.textLabel?.textColor = UIColor.white
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            
            let currentCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
            

            let document = self.database.collection("users").document(Auth.auth().currentUser!.uid)
            document.updateData(["userTasks": FieldValue.arrayRemove(["\(currentCell!)"])]) { (err) in
                
                if err != nil
                {
                    print("Error deleting")
                }
                else
                {
                    print("task array before \(self.tasksArray)")
                    self.tasksArray.remove(at: indexPath.row)
                    print("After task array \(self.tasksArray)")
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        return [deleteAction]
    }
    
    //MARK: Sign Out User
    
    @IBAction func signOutPressed(_ sender: UIButton)
    {
        signUserOut()

    }
    
    func signUserOut(){
        
        do{
            try Auth.auth().signOut()
            self.userDefaults.set(false, forKey: "isLoggedIn")
            self.transitionToWelcome()
        }
        
        catch{
        }
    }
    @IBAction func syncBtnPressed(_ sender: Any)
    {
        self.retrieveData()
        self.tableView.reloadData()
    }
    
     func transitionToWelcome(){
          let welcomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.WelcomeViewController) as? WelcomeViewController
          view.window?.rootViewController = welcomeVC
          view.window?.makeKeyAndVisible()
      }

}
