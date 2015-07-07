//
//  RegisterViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: ViewController, UserDAOCloudKitDelegate{
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTexteField: UITextField!
    
    @IBOutlet var confirmPasswordTextFied: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func  viewWillAppear(animated: Bool) {
        
    }
    
    func errorThrowed(error: NSError){
        println("errorThrowed")
    }
    func userStillInserted(user: User){
        println("userStillInserted")
    }
    func saveUserFinished(user: User){
        //changeView("geolocation", animated: true)
        println("oloko")
    }
    func userNotFound(user : User){
        println("userNotFound")
    }
    func getUserFinished(user: User){
        println("getUserFinished")
    
    }
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        if((passwordTextField.text == confirmPasswordTextFied.text) || passwordTextField.text != ""){
            
            var userDao :UserDAOCloudKit = UserDAOCloudKit()
            userDao.delegate = self
            
            var user: User = User(name: nameTextField.text, password: passwordTextField.text, email: emailTexteField.text)

            userDao.saveUser(user)
            
        }
        
    }
    
    func changeView(indentifier: String, animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(indentifier) as! RegisterViewController
        self.presentViewController(nextViewController, animated:animated, completion:nil)
    }
}
