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

    
    let facebookReadPermissions = ["public_profile", "email", "user_photos"]
    
    var usuario: UserManager = UserManager()
    
    var fbResponder: FacebookResponder!
    
    //MARK: View functions
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.title = "Login"
        
        IHKeyboardAvoiding.setAvoidingView(self.view)
        
    }
    
    
    func danilo(){
        userToIconDistance.constant = userToIconDistance.constant * self.view.frame.size.height / 667.0
        textDistances.constant = textDistances.constant * self.view.frame.size.height / 667.0
        
        
        
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            
            if session != nil{
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
                println(session.userName)
                
                nextViewController.nomeUser = session.userName
                
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }else {
                DispatcherClass.dispatcher({ () -> () in
                    
                    var action: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                    }
                    
                    
                    // Add the actions
                    action.addAction(okAction)
                    
                    self.presentViewController(action, animated: true, completion: nil)
                    
                })
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usuario.delegate = self
        
        appIcon.layer.cornerRadius = appIcon.frame.size.height / 2.0
        
        danilo()
        
    }

    
    
    //Some other options: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"
    
    func loginToFacebookWithSuccess(successBlock: () -> (), andFailure failureBlock: (NSError?) -> ()) {
        
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/{user-id}", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                var id = result.valueForKey("id") as! NSString!
                var name = result.valueForKey("name") as! NSString!
                var email = result.valueForKey("email") as! NSString!
                println(result) // This works
                
                
            }
        })
        
//        var request:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/{user-id}", parameters: , HTTPMethod: "GET")
//        
//        
//        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, id:AnyObject!, error:NSError!) -> Void in
//            
//        }


        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            //FBSDKLoginManager().logOut()
            //Otherwise do:
            return
        }
        
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
                failureBlock(error)
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
                failureBlock(nil)
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                //result.grantedPermissions returns an array of _NSCFString pointers
                let grantedPermissions = result.grantedPermissions
                for permission in self.facebookReadPermissions {
                    if !contains(grantedPermissions, permission) {
                        allPermsGranted = false
                        
                        break
                    }
                }
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    let fbUserID = result.token.userID
                    
                    //Send fbToken and fbUserID to your web API for processing, or just hang on to that locally if needed
//                    self.post("myserver/myendpoint", parameters: ["token": fbToken, "userID": fbUserID]) {(error: NSError?) ->() in
//                    	if error != nil {
//                    		failureBlock(error)
//                    	} else {
//                    		successBlock(maybeSomeInfoHere?)
//                    	}
//                    }
                    
                    successBlock()
                } else {
                    //The user did not grant all permissions requested
                    //Discover which permissions are granted
                    //and if you can live without the declined ones
                    
                    failureBlock(nil)
                }
            }
        })
    }

    
    
    func returnUserData()
    {
        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: LogIn and SignIn
    
    @IBAction func logInAction(sender: AnyObject) {
        
        activityIndicator.activityViewWithName(self, texto: "Buscando Usuário")

        var user: User = User(name: nomeText.text, email: nomeText.text)
        
        usuario.getUserDatabase(user, password: self.senhaText.text)

    }
    
    @IBAction func registerAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    //MARK: UserManager Delegate
    
    func errorThrowedSystem(error: NSError) {
        activityIndicator.removeActivityViewWithName()
    }
    
    func userNotFound(user : User){
        activityIndicator.removeActivityViewWithName()
        println("userNotFound")
    }
    func getUserFinished(user: User){
        UserDAODefault.saveLogin(user)
        activityIndicator.removeActivityViewWithName()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("navigationHome") as! UINavigationController
        self.presentViewController(nextViewController, animated:true, completion:nil)

    }
    
    
    
    
    
    //MARK: FBResponder Delegate
    
    func loggedIn(result:FBSDKLoginManagerLoginResult, error: NSError!) {
        
        //Login Successful
        if error == nil {
            
//            var usuario: UserManager = UserManager()
//            usuario.delegate = self
//
//            var user: User = User(name:, email: nomeText.text)
//            
//            usuario.getUserDatabase(user, password: self.senhaText.text)
//            
//            usuario.insertUserDatabase(<#user: User#>, password: <#String#>)
//            
//            UserDAODefault.saveLogin(user)
            
            
            
            
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: result.token.userID, parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    // Process error
                    println("Error: \(error)")
                }
                else
                {
                    var id = result.valueForKey("id") as! NSString!
                    var name = result.valueForKey("name") as! NSString!
                    var email = result.valueForKey("email") as! NSString!
                    println(result) // This works
                    
                    
                }
            })
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("register") as! RegisterViewController

            
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        //Login Failed
        else {
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    func loggedOut() {
        
    }
    
    
    
    
//    func userFriendsReceived(friends: [FacebookUser], error: NSError!) {
//        
//        if error == nil {
//        
//            for var x = 0; x < friends.count; x++ {
//                println(friends[x].name)
//            }
//        }
//        
//        else {
//            
//        }
//    }
    func errorThrowedServer(stringError : String){
        
        var action: UIAlertController = UIAlertController(title: "Error", message: stringError, preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        
        // Add the actions
        action.addAction(okAction)
        
        self.presentViewController(action, animated: true, completion: nil)
        
        println(stringError)
    }


}



