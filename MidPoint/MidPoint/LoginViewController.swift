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


class LoginViewController: UIViewController, UserManagerDelegate {

    
    @IBOutlet weak var userToIconDistance: NSLayoutConstraint!
    @IBOutlet weak var textDistances: NSLayoutConstraint!
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet var nomeText: UITextField!
    @IBOutlet var senhaText: UITextField!

    
    var activity: activityIndicator?
    
    var usuario: UserManager = UserManager()
    
    var fbResponder: FacebookResponder!
    
    //MARK: View functions
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.title = "Login"
        
        IHKeyboardAvoiding.setAvoidingView(self.view)
        
    }
    @IBAction func buttonTwitterTouch(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                println("signed in as \(session.userName)");
            } else {
                println("error: \(error.localizedDescription)");
            }
        }
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        usuario.delegate = self
        
        appIcon.layer.cornerRadius = appIcon.frame.size.height / 2.0
        
       // danilo()
        
    }
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
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
    }
    
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //MARK: LogIn and SignIn
    
    @IBAction func logInAction(sender: AnyObject) {
        
        activity = activityIndicator(view: self.navigationController!, texto: "Buscando Usuário")

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
        activity?.removeActivityViewWithName()
    }
    
    func userNotFound(user : User){
        activity?.removeActivityViewWithName()
        println("userNotFound")
    }
    func getUserFinished(user: User){
        UserDAODefault.saveLogin(user)
        activity?.removeActivityViewWithName()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("navigationHome") as! UINavigationController
        self.presentViewController(nextViewController, animated:true, completion:nil)

    }
    
    
    
    
    
    //MARK: FBResponder Delegate
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    func loggedOut() {
        
    }
    func errorThrowedServer(stringError : String){
        
        activity?.removeActivityViewWithName()
        
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



