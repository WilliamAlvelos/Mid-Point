//
//  RegisterViewController.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: UIViewController, UserManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var pickerLibrary : UIImagePickerController?
    
    var user : User?
    
    private var  userManager :UserManager = UserManager()
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTexteField: UITextField!
    
    @IBOutlet var confirmPasswordTextFied: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.delegate = self

        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        
        IHKeyboardAvoiding.setAvoidingView(self.view)
        
        button.layer.cornerRadius = button.bounds.size.width/2
        button.layer.borderWidth = 0
        button.layer.masksToBounds = true
        user = User()
    }
    
    override func  viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
        
//        passwordTextField.hidden = true
//        emailTexteField.hidden = true
//        confirmPasswordTextFied.hidden = true
        

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.passwordTextField.center.x -= view.bounds.width * 2
//        self.emailTexteField.center.x -= view.bounds.width * 2
//        self.confirmPasswordTextFied.center.x -= view.bounds.width * 2
//        self.nameTextField.center.x -= view.bounds.width * 2
//        
//
//        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.nameTextField.center.x += self.view.bounds.width
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.emailTexteField.center.x += self.view.bounds.width
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.passwordTextField.center.x += self.view.bounds.width
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.confirmPasswordTextFied.center.x += self.view.bounds.width
//            self.view.layoutIfNeeded()
//            }, completion: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
//        self.nameTextField.hidden = true
//        self.emailTexteField.hidden = true
//        self.passwordTextField.hidden = true
//        self.confirmPasswordTextFied.hidden = true
        
    }
    
    func userStillInserted(user: User){
        println("userStillInserted")
    }
    func saveUserFinished(user: User){
        //changeView("geolocation", animated: true)
        UserDAODefault.saveLogin(user)
        PictureCloudKit().uploadImageUser(user)
        TransitionManager(indentifier: "navigationHome", animated: true, view: self)
    }
    func userNotFound(user : User){
        println("userNotFound")
    }

    
    @IBAction func changeImage(sender: AnyObject) {
        
        var actionsheet: UIAlertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in

            self.pickerLibrary?.sourceType = .Camera
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        let roloCamera = UIAlertAction(title: "Rolo de camera", style: .Default,handler: { (alert: UIAlertAction!) -> Void in
            self.pickerLibrary?.sourceType = .PhotoLibrary
            self.pickerLibrary?.allowsEditing = true
            self.presentViewController(self.pickerLibrary!, animated: true, completion: nil)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,handler:{ (alert: UIAlertAction!) -> Void in
            println("cancelar")
        })
        
        actionsheet.addAction(cameraAction)
        actionsheet.addAction(roloCamera)
        actionsheet.addAction(cancelAction)
        
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        let data : NSData = NSData(data: UIImageJPEGRepresentation(image, 1))
        data.writeToFile(self.imagePathURL().path!, atomically: true)
        
        button.setBackgroundImage(image, forState: .Normal)
        user?.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    private func imagePathURL()->NSURL{
        return NSURL.fileURLWithPath(NSString(format: "%@%@", aplicationDocumentsDirectory(),"/userPhoto.JPG") as String)!
    }
    
    private func aplicationDocumentsDirectory()->NSString{
        var paths :NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0] as! NSString
    }
//
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        if((passwordTextField.text == confirmPasswordTextFied.text) || passwordTextField.text != ""){
            
            
            self.user?.name = nameTextField.text
            self.user?.email = emailTexteField.text
            userManager.insertUserDatabase(self.user!, password : passwordTextField.text)
            
        }
        
    }
    func progressUpload(float: Float) {
        println(float)
    }
    func saveUserFinished() {
        
    }
    func errorThrowedSystem(error: NSError) {
        
    }
    
}
