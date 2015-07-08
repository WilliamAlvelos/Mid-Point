//
//  UserManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit

@objc protocol UserManagerDelegate{
    func errorThrowed(error: NSError)
    func userNotFound(user : User)
    optional func getUserFinished(user: User)
    optional func userStillInserted(user: User)
    optional func saveUserFinished(user: User)
}

class UserManager: UserDAOCloudKitDelegate{
    
    private var userDao: UserDAOCloudKit?
    
    var delegate:UserManagerDelegate?
    
    init(){
        userDao = UserDAOCloudKit()
        userDao?.delegate = self
    }
    
    
    func errorThrowed(error: NSError){
        self.delegate?.errorThrowed(error)
    }
    
    func userStillInserted(user: User){
        self.delegate?.userStillInserted!(user)
    }
    
    func saveUserFinished(user: User){
        self.delegate?.saveUserFinished!(user)
    }
    
    func userNotFound(user : User){
        self.delegate?.userNotFound(user)
    }
    
    func getUserFinished(user: User){
        self.delegate?.getUserFinished!(user)
    }

    
    func createUser()->User{
        return User()
    }
    
    func insertUserDatabase(user:User){
        userDao?.saveUser(user)
    }
    
    func getUserDatabase(user:User){
        userDao?.getUser(user)
    }
    
    
}
