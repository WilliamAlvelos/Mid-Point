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
    optional func downloadImageUserFinished(user: User)
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
        if name == "" {
            let error = NSError(domain: "Event error", code: 1, userInfo: nil)
            self.delegate?.errorThrowedSystem(error)
            return
        }
        userDao?.getUsersWithName(name)
    }
    func saveImageFinished(){
        self.delegate?.saveUserFinished?()
    }
    func getUsersFinished(users: Array<User>){
        self.delegate?.getUsersFinished?(users)

    }

    func getUsersFrom(event: Event){
        userDao?.getUsersFrom(event)
    }
    func getImage(user : User){
        
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            user.image = self.userDao?.downloadImage(user.id!)
            DispatcherClass.dispatcher({ () -> () in
                self.delegate?.downloadImageUserFinished?(user)
            })
            
        })

    }
    func updateUserLocationAndState(user: User , location : Localizacao?, event : Event, state: Option){
        userDao?.updateUserLocationAndState(user, location: location, event: event, state: state)
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
