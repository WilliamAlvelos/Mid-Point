//
//  ActionError.swift
//  MidPoint
//
//  Created by William Alvelos on 30/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation


class ActionError {
    
    
    
    
    init(){
    
    }
    
    
    class func actionError(error: String, errorMessage: String, view: UIViewController){
    
        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        

        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in

        }
        
        
        alertController.addAction(okAction)
        
        view.presentViewController(alertController, animated: true, completion: nil)
    
    
    }
    
    class func actionWithTextField(error: String, errorMessage:String, placeholder:String, view: CreateConversationViewController, title: Bool) {

        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
         var inputTextField: UITextField?

        
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            textField.placeholder = placeholder
            inputTextField = textField
        })
        
        
        if(title){
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                view.titleGroup.text = inputTextField?.text
            }
        
            
            alertController.addAction(okAction)
        }else{
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                view.subtitleGroup.text = inputTextField?.text
            }
            
            alertController.addAction(okAction)
        }
        

        
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    class func actionErrorWithTextField(error: String, errorMessage:String, placeholder:String, view: RegisterViewController) {
        
        
        var alertController = UIAlertController(title: error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        var inputTextField: UITextField?

        
        alertController.addTextFieldWithConfigurationHandler({ textField -> Void in
            textField.placeholder = placeholder
            inputTextField = textField
        })
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            view.nameTextField.text = inputTextField?.text
        }
        

        alertController.addAction(okAction)
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}