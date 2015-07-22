//
//  FacebookResponder.swift
//  MidPoint
//
//  Created by Danilo Mative on 22/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class FacebookResponder: NSObject, FBSDKLoginButtonDelegate, FBSDKAppInviteDialogDelegate {
   
    
    var fbButton: FBSDKLoginButton!
    
    func logOutFromFacebook() {
        
    }
    
    func facebookButtonWithFrame(frame:CGRect)->FBSDKLoginButton {
        
        fbButton = FBSDKLoginButton()
        fbButton.delegate = self
        fbButton.readPermissions = ["public_profile", "email", "user_friends"]
        fbButton.frame = frame
        
        return fbButton
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            //Login succesfull
            
            //App invite test
            //            let content = FBSDKAppInviteContent()
            //            content.appLinkURL = NSURL(string: "https://fb.me/399922950197556")
            //            content.appInvitePreviewImageURL = NSURL()
            //
            //            FBSDKAppInviteDialog.showWithContent(content, delegate: self)
            
            //Get user friends
            let dic = Dictionary(dictionaryLiteral: ("name",""))
            var request = FBSDKGraphRequest(graphPath:"me/friends?fields=id,name", parameters: nil, HTTPMethod:"GET");
            
            request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    //println("Friends are : \(result)")
                    
                    let dic = result as! NSDictionary
                    let data = dic.objectForKey("data") as! NSArray
                    
                    for var x = 0; x < data.count; x++ {
                        let object = data[x] as! NSDictionary
                        
                        println("name:" + (object.objectForKey("name") as! String))
                    }
                    
                } else {
                    println("Error Getting Friends \(error)");
                }
            }
        }
            
        else {
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
     func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        
    }
    
    
}
