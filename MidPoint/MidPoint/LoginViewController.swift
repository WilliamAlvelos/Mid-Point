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

    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet var nomeText: UITextField!
    @IBOutlet var senhaText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var labelCadastre: UILabel!
    @IBOutlet weak var labelOu: UILabel!
    var activity: activityIndicator?
    
    var usuario: UserManager = UserManager()

    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
            
//        if(UserDAODefault.getLoggedUser().id != nil){
//            
//            let nextViewController = TransitionManager.creatView("navigationHome") as! UINavigationController
//            self.presentViewController(nextViewController, animated:true, completion:nil)
//        }
        
        usuario.delegate = self
        self.view.backgroundColor = Colors.Azul
        appIcon.layer.cornerRadius = appIcon.frame.size.height / 2.0
        
        
       
            
            //UIMPConfiguration.configureNavigationBar(self.navigationController!.navigationBar, color: Colors.Azul)
        UIMPConfiguration.configureTextField(self.nomeText, text: "qual o seu email?")
        UIMPConfiguration.configureTextField(self.senhaText, text: "e a sua senha secreta?")
        
            
            
            
        UIMPConfiguration.addBorderToView(self.loginButton, color: Colors.Rosa, width: 3.0, corner: 25.0)
        UIMPConfiguration.addColorAndFontToButton(self.loginButton, color: Colors.Rosa, fontName: FontName.ButtonFont, fontSize: 20)
        UIMPConfiguration.addColorAndFontToButton(self.createAccountButton, color: Colors.Rosa, fontName: FontName.ButtonFont, fontSize: 18)
        UIMPConfiguration.addColorAndFontToLabel(self.labelCadastre, color: UIColor.whiteColor(), fontName: FontName.LabelFont, fontSize: 14)
        UIMPConfiguration.addColorAndFontToLabel(self.labelOu, color: UIColor.whiteColor(), fontName: FontName.LabelFont, fontSize: 12)
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
        
        activity = activityIndicator(view: self.navigationController!, texto: "Buscando Usuário", inverse: true, viewController: self)

        var user: User = User(name: nomeText.text, email: nomeText.text)
        
        usuario.getUserDatabase(user, password: self.senhaText.text)
        
        self.view.endEditing(true)

    }
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        let nextViewController = TransitionManager.creatView("register") as! RegisterViewController
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    //MARK: UserManager Delegate
    
    func errorThrowedSystem(error: NSError) {
        activity?.removeActivityViewWithName(self)
    }
    
    func userNotFound(user : User){
        activity?.removeActivityViewWithName(self)
        println("userNotFound")
    }
    func getUserFinished(user: User){
        PushResponse.createNewDeviceToPush(user)
        UserDAODefault.saveLogin(user)
        
        let nextViewController = TransitionManager.creatView("navigationHome") as! UINavigationController
        activity?.removeActivityViewWithName(self)

        self.presentViewController(nextViewController, animated:true, completion:nil)

    }
    
    
    
    
    
    //MARK: FBResponder Delegate
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func loggedOut() {
        
    }
    func errorThrowedServer(stringError : String){
        
        activity?.removeActivityViewWithName(self)
        
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



