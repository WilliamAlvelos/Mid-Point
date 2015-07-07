//
//  LoginViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UserManagerDelegate{
    
    @IBOutlet var nomeText: UITextField!
    
    @IBOutlet var senhaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    }
    
    override func  viewWillAppear(animated: Bool) {
        
    }
    
    
    @IBAction func logInAction(sender: AnyObject) {
        var usuario: UserManager = UserManager()
        usuario.delegate = self
        
        var user: User = User(name: nomeText.text, password: senhaText.text, email: nomeText.text)
        
        usuario.getUserDatabase(user)

    }
    
    @IBAction func registerAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    
    func errorThrowed(error: NSError){
        println("errorThrowed")
    }
    func userStillInserted(user: User){
        println("userStillInserted")
    }
    func saveUserFinished(user: User){
        println("oloko")
    }
    func userNotFound(user : User){
        println("userNotFound")
    }
    func getUserFinished(user: User){
        println("getUserFinished")
    }

}
