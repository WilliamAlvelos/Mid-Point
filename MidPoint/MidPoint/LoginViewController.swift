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
    
    @IBOutlet weak var userToIconDistance: NSLayoutConstraint!
    @IBOutlet weak var textDistances: NSLayoutConstraint!
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet var nomeText: UITextField!
    @IBOutlet var senhaText: UITextField!
    var usuario: UserManager = UserManager()
    
    var fbResponder: FacebookResponder!
    
    //MARK: View functions
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.title = "Login"

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usuario.delegate = self

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
 
        userToIconDistance.constant = userToIconDistance.constant * self.view.frame.size.height / 667.0
        textDistances.constant = textDistances.constant * self.view.frame.size.height / 667.0
        
        
        appIcon.layer.cornerRadius = appIcon.frame.size.height / 2.0
        
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
        
        
        fbResponder = FacebookResponder()
        fbResponder.delegate = self
        
        
        var fbButton = fbResponder.facebookButtonWithFrame(nomeText.frame)
    
        fbButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        logInButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addSubview(logInButton)
        self.view.addSubview(fbButton)
        
        //Facebook button constraints
        self.view.addConstraint(NSLayoutConstraint(item: fbButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nomeText, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 1.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: fbButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nomeText, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 1.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: fbButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: nomeText, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: textDistances.constant * -5.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: fbButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        
        
        //Twitter button constraints
        self.view.addConstraint(NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nomeText, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 1.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nomeText, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 1.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: fbButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: nomeText.frame.size.height + textDistances.constant))
        
        self.view.addConstraint(NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))

    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: LogIn and SignIn
    
    @IBAction func logInAction(sender: AnyObject) {

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
        self.presentViewController(nextViewController, animated:true, completion:nil)
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



