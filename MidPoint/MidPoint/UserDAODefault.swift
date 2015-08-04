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
        userFixo.setBool(true, forKey: UserGlobalConstants.LoggedNow)
        userFixo.setObject(user.name, forKey: UserGlobalConstants.Name)
        userFixo.setInteger(user.id!, forKey: UserGlobalConstants.Id)
        userFixo.setObject(user.email, forKey: UserGlobalConstants.Email)
       // userFixo.setObject(user.image, forKey: "user_image")
        userFixo.synchronize()
    }
    
    class func getLoggedUser()->User{

        let userFixo = NSUserDefaults.standardUserDefaults()
        var user:User = User()
        
        user.name = userFixo.objectForKey(UserGlobalConstants.Name) as? String
        user.id = userFixo.objectForKey(UserGlobalConstants.Id) as? Int
        user.email = userFixo.objectForKey(UserGlobalConstants.Email) as? String
        return user
    }
}