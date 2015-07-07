//
//  LoginViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: ViewController, UserDAOCloudKitDelegate{
    
    @IBOutlet var nomeText: UITextField!
    
    @IBOutlet var senhaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
    }
    
    override func  viewWillAppear(animated: Bool) {
        
    }
    
    
    @IBAction func logInAction(sender: AnyObject) {
        var userDao: UserDAOCloudKit = UserDAOCloudKit()
        userDao.delegate = self
        
        var usuario: User = User(name: nomeText.text, password: senhaText.text, email : nomeText.text)
        userDao.getUser(usuario, option: .Get)
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
