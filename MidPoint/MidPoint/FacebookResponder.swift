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

@objc protocol FBResponderDelegate {
    
    func loggedIn(result :FBSDKLoginManagerLoginResult, error:NSError!)
    func loggedOut()
    optional func userFriendsReceived(friends:[FacebookUser], error:NSError!)
    optional func loginStatus()
    
}

class FacebookResponder: NSObject, FBSDKLoginButtonDelegate, FBSDKAppInviteDialogDelegate {
   
    var isLoggedIn: Bool!
    var fbButton: FBSDKLoginButton!
    var delegate = FBResponderDelegate?()
    
    
    func inviteUserFriends() {
        
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://fb.me/399922950197556")
        content.appInvitePreviewImageURL = NSURL()
        
        FBSDKAppInviteDialog.showWithContent(content, delegate: self)
    }
    
    
    func getUserFacebookFriends()->[FacebookUser] {
        
        var array = [FacebookUser]()
        
        //Get user friends
        let dic = Dictionary(dictionaryLiteral: ("name",""))
        
        var request = FBSDKGraphRequest(graphPath:"me/friends?fields=id,name", parameters: nil, HTTPMethod:"GET")
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                let dic = result as! NSDictionary
                let data = dic.objectForKey("data") as! NSArray
                
                for var x = 0; x < data.count; x++ {
                    let object = data[x] as! NSDictionary
                    
                    var name = object.objectForKey("name") as! String
                    var id = object.objectForKey("id") as! String
                    
                    var new = FacebookUser(name: name, id: id)
                    
                    array.append(new)
                }
                
                self.delegate?.userFriendsReceived!(array,error:nil)
                
            }
            
            else {
                
                println("Error Getting Friends \(error)")
                
                self.delegate?.userFriendsReceived!(array, error:error)
            }
        }
        
        return array
    }

    
    func facebookButtonWithFrame(frame:CGRect)->FBSDKLoginButton {
        
        isLoggedIn = false
        
        fbButton = FBSDKLoginButton()
        fbButton.delegate = self
        fbButton.readPermissions = ["public_profile", "email", "user_friends"]
        fbButton.frame = frame
        
        return fbButton
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        delegate?.loggedIn(result, error: error)
        
        if error == nil {
        
            isLoggedIn = true
        }
            
        else {
            println(error)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        isLoggedIn = false

        delegate?.loggedOut()
    }
    
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
     func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        
    }
    
    
}
