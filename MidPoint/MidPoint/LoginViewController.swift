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
                let user = User()
                user.name = session.userName
                nextViewController.user = user
                
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
                    var id = result.valueForKey("id") as! String
                    var name = result.valueForKey("name") as! String
                    var email = result.valueForKey("email") as! String
                    var image = "https://graph.facebook.com/\(id)/picture?type=large"
                    
                    
                    var imageFacebook : UIImage?
                    
                    let url = NSURL(string: image)
                    
                    var request = NSMutableURLRequest(URL: url!)
                    request.timeoutInterval = 5
                    var response: NSURLResponse?
                    var error: NSError?
                    let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                    if urlData == nil || error != nil || NSString(data: urlData!, encoding: NSUTF8StringEncoding) != nil{
                        imageFacebook = UIImage(named: "logo")
                        
                    }
                    imageFacebook = UIImage(data: urlData!)
                
                    let nextView = TransitionManager.creatView("register") as! RegisterViewController
                    let user = User()
                    user.name = name
                    user.email = email
                    user.image = imageFacebook
                    nextView.user = user
                    
                    DispatcherClass.dispatcher({ () -> () in
                        
                    
                        self.navigationController?.pushViewController(nextView, animated: true)
                        
                    })
                    
                }
            })
            
            

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



