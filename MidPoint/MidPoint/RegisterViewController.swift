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
    @IBOutlet var button: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTexteField: UITextField!
    
    @IBOutlet var confirmPasswordTextFied: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerLibrary = UIImagePickerController()
        pickerLibrary!.delegate = self
        button.layer.cornerRadius = button.bounds.size.width/2
        button.layer.borderWidth = 0
        button.layer.masksToBounds = true
    }
    
    override func  viewWillAppear(animated: Bool) {
        
        PermissionsResponse.checkCameraPermission()
        PermissionsResponse.checkRollCameraPermission()
        
        
        passwordTextField.center.x  -= view.bounds.width
        emailTexteField.center.x -= view.bounds.width
        confirmPasswordTextFied.center.x -= view.bounds.width
        nameTextField.center.x -= view.bounds.width
        
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.nameTextField.center.x += self.view.bounds.width

            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.emailTexteField.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.passwordTextField.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.confirmPasswordTextFied.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)



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
    
    func userStillInserted(user: User){
        println("userStillInserted")
    }
    func saveUserFinished(user: User){
        //changeView("geolocation", animated: true)
        println("oloko")
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
        println("%@", self.imagePathURL().path!)
        
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
            
            var userManager :UserManager = UserManager()
            userManager.delegate = self
            
            var user: User = User(name: nameTextField.text, password: passwordTextField.text, email: emailTexteField.text)
            user.image = self.user?.image
            userManager.insertUserDatabase(user)
            
        }
        
    }
    
    func changeView(indentifier: String, animated: Bool){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(indentifier) as! RegisterViewController
        self.presentViewController(nextViewController, animated:animated, completion:nil)
    }
}
