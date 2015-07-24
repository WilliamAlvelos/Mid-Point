//
//  UserDAODefault.swift
//  MidPoint
//
//  Created by William Alvelos on 24/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation


class UserDAODefault {
    
    
    class func saveLogin(user: User){
        let userFixo = NSUserDefaults.standardUserDefaults()
        
        userFixo.setObject(user.name, forKey: "user_name")
        userFixo.setInteger(user.id!, forKey: "user_id")
        userFixo.setObject(user.email, forKey: "user_email")
        userFixo.setObject(user.image, forKey: "user_image")
        userFixo.synchronize()
    }
    
    class func getLoggedUser()->User{

        let userFixo = NSUserDefaults.standardUserDefaults()
        var user:User = User()
        
        user.name = userFixo.objectForKey("user_name") as? String
        user.id = userFixo.objectForKey("user_id") as? Int
        user.email = userFixo.objectForKey("user_email") as? String
        return user
    }
}