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
        
        userFixo.setObject(user.name, forKey: UserGlobalConstants.NameUser)
        userFixo.setInteger(user.id!, forKey: UserGlobalConstants.IdUser)
        userFixo.setObject(user.email, forKey: UserGlobalConstants.EmailUser)
        userFixo.setObject(user.image, forKey: "user_image")
        userFixo.synchronize()
    }
    
    class func getLoggedUser()->User{

        let userFixo = NSUserDefaults.standardUserDefaults()
        var user:User = User()
        
        user.name = userFixo.objectForKey(UserGlobalConstants.NameUser) as? String
        user.id = userFixo.objectForKey(UserGlobalConstants.IdUser) as? Int
        user.email = userFixo.objectForKey(UserGlobalConstants.EmailUser) as? String
        return user
    }
}