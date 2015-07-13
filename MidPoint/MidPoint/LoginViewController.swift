//
//  LoginViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit


class LoginViewController: UIViewController, UserManagerDelegate{
    
    @IBOutlet var nomeText: UITextField!
    
    @IBOutlet var senhaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//            let logInButton = TWTRLogInButton(logInCompletion: {
//            (session: TWTRSession!, error: NSError!) in
//            
//            
//             play with Twitter session
//            
//
//            if session != nil{
//                println(session.userName)
//                println(session.userID)
//                println(session.authTokenSecret)
//                println(session.authToken)
//                
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("geolocation") as! GeolocationViewController
//                nextViewController.nomeUser = session.userName
//                self.presentViewController(nextViewController, animated:true, completion:nil)
//                
//                
//            }else {
//                println("error: \(error.localizedDescription)");
//            }
//        
//        })
//        
//        
//
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)
//


    }
    
    override func  viewWillAppear(animated: Bool) {
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func logInAction(sender: AnyObject) {
        var usuario: UserManager = UserManager()
        usuario.delegate = self
        
        var user: User = User(name: nomeText.text, email: nomeText.text)
        
        usuario.getUserDatabase(user, password: self.senhaText.text)

    }
    
    @IBAction func registerAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    
    func errorThrowed(error: NSError){
        
        if error.code == 3 || error.code == 4{
            println("BAD INTERNET")
        }else if error.code == 9 || error.code == 1{
            println("nao esta logado no icloud fdp")
        }else{
            println("internal error")
        }

    }

    func userNotFound(user : User){
        println("userNotFound")
    }
    func getUserFinished(user: User){
        println("getUserFinished")
    }

}



