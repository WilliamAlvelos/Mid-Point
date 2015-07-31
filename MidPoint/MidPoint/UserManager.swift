//
//  UserManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import Foundation
import UIKit
import Parse

@objc protocol UserManagerDelegate{
    func errorThrowedSystem(error: NSError)
    func errorThrowedServer(stringError : String)
    optional func userNotFound(user : User)
    optional func getUserFinished(user: User)
    optional func userStillInserted(user: User)
    optional func saveUserFinished()
    optional func progressUpload(float : Float)
    optional func getUsersFinished(users: Array<User>)
    optional func downloadImageFinished(image: Array<User>)
    optional func updateStateFinished()
    optional func updateLocationFinished()
    optional func getLocationFinished(users: Array<Localizacao>)
}

class UserManager: UserDAOCloudKitDelegate, PictureCloudKitDelegate{
    
    private var userDao: UserDAOCloudKit?
    private var pictureDao : PictureCloudKit?
    var delegate:UserManagerDelegate?
    
    init(){
        userDao = UserDAOCloudKit()
        userDao?.delegate = self
        pictureDao = PictureCloudKit()
        pictureDao?.delegate = self
    }
    
    func progressUpload(float : Float){
        self.delegate?.progressUpload?(float)
    }
    
    func errorThrowed(error: NSError){
        self.delegate?.errorThrowedServer(ErrorHandling.stringForError(error))
    }
    
    func userStillInserted(user: User){
        self.delegate?.userStillInserted!(user)
    }
    
    func saveUserFinished(user: User){
            PushResponse.createNewDeviceToPush(user)
            pictureDao?.uploadImageUser(user)
    }
    
    func userNotFound(user : User){
        self.delegate?.userNotFound?(user)
    }
    
    func getUserFinished(user: User){
        self.delegate?.getUserFinished?(user)
    }
    func insertUserDatabase(user:User, password : String){
        userDao?.saveUser(user, password: password)
    }
    func getUserDatabase(user:User, password : String){
        userDao?.getUser(user, password: password)
    }
    func getUsersWithName(name : String){
        userDao?.getUsersWithName(name)
    }
    func saveImageFinished(){
        self.delegate?.saveUserFinished?()
    }
    func getUsersFinished(users: Array<User>){
        self.delegate?.getUsersFinished?(users)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.getImages(users)
        }
        

    
    }

    func getUsersFrom(event: Event){
        userDao?.getUsersFrom(event)
    }
    func getImages(users : Array<User>){
        for var x = 0 ; x < users.count ; x++ {
            users[x].image = self.userDao?.downloadImage(users[x].id!)
        }

        DispatcherClass.dispatcher { () -> () in
            self.delegate?.downloadImageFinished?(users)
        }
    }
    func updateUserState(user: User , state : Option, event : Event){
        userDao?.updateUserState(user, state: state, event: event)
    }
    func updateStateFinished() {
        self.delegate?.updateStateFinished?()
    }
    func updateLocationFinished() {
        self.delegate?.updateLocationFinished?()
    }
    func getLocationFinished(users: Array<Localizacao>) {
        self.delegate?.getLocationFinished?(users)
    }
    
}
