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
import FBSDKLoginKit


class LoginViewController: UIViewController, UserManagerDelegate, FBResponderDelegate {
    
    @IBOutlet var nomeText: UITextField!
    
    @IBOutlet var senhaText: UITextField!
    
    var fbResponder: FacebookResponder!
    
    //MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
            let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            

            if session != nil{
                
                var user: User = User(userIdTwitter: session.userID, userNameTwitter: session.userName)
                println(session.userName)
                println(session.userID)
                println(session.authTokenSecret)
                println(session.authToken)
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("geolocation") as! GeolocationViewController
                nextViewController.nomeUser = session.userName
                self.presentViewController(nextViewController, animated:true, completion:nil)
                
                
            }else {
                println("error: \(error.localizedDescription)");
            }
        
        })
        
        

        logInButton.center = self.view.center
        self.view.addSubview(logInButton)


        fbResponder = FacebookResponder()
        fbResponder.delegate = self
        
        var fbButton = fbResponder.facebookButtonWithFrame(nomeText.frame)
        
        fbButton.frame.origin.y = self.view.frame.size.height - (fbButton.frame.size.height * 3.0)
        
        self.view.addSubview(fbButton)

    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
        fbResponder.inviteUserFriends()
    }
    
    //MARK: LogIn and SignIn
    
    @IBAction func logInAction(sender: AnyObject) {
        var usuario: UserManager = UserManager()
        usuario.delegate = self
        
        var user: User = User(name: nomeText.text, email: nomeText.text)
        
        usuario.getUserDatabase(user, password: self.senhaText.text)

    }
    
    @IBAction func registerAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: false)
        
    }
    
    //MARK: UserManager Delegate
    
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
        UserDAODefault.saveLogin(user)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("navigationControllerConversas") as! UINavigationController
        self.presentViewController(nextViewController, animated:false, completion:nil)
    }
    
    
    //MARK: FBResponder Delegate
    
    func loggedIn(error: NSError!) {
        
        //Login Successful
        if error == nil {
            
        }
        
        //Login Failed
        else {
            
        }
    }
    
    func loggedOut() {
        
    }
    
    func userFriendsReceived(friends: [FacebookUser], error: NSError!) {
        
        if error == nil {
        
            for var x = 0; x < friends.count; x++ {
                println(friends[x].name)
            }
        }
        
        else {
            
        }
    }

}



