//
//  UserManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
@objc protocol EventManagerDelegate{
    func errorThrowedServer(error: NSError)
    optional func saveEventFinished(event: Event)
    optional func eventNotFound(event : Event)
    optional func getEventFinished(event: Event)
    optional func getEventsFinished(events: Array<Event>)
    optional func inviteFinished(event: Event)
    optional func uploadImageFinished()
    optional func progressUpload(float : Float)
    func errorThrowedSystem(error: NSError)
}
class EventManager: EventoDAOCloudKitDelegate, PictureCloudKitDelegate{
    private var eventDao : EventDAOCloudKit?
    private var pictureDao : PictureCloudKit?
    var delegate : EventManagerDelegate?
    init(){
        eventDao = EventDAOCloudKit()
        eventDao?.delegate = self
        pictureDao = PictureCloudKit()
        pictureDao?.delegate = self
    }
    func errorThrowed(error: NSError){
        self.delegate?.errorThrowedServer(error)
    }
    func saveEventFinished(event: Event){
        self.delegate?.saveEventFinished?(event)
    }
    func eventNotFound(event : Event){
        self.delegate?.eventNotFound?(event)
    }
    func getEventFinished(event: Event){
        self.delegate?.getEventFinished?(event)
    }
    func getEventsFinished(events: Array<Event>){
        self.delegate?.getEventsFinished?(events)
    }
    func inviteFinished(event: Event){
        self.delegate?.inviteFinished?(event)
        pictureDao?.uploadImageEvent(event)
    }
    func errorCloudKit(error: NSError){
        
    }
    func progressUpload(float : Float){
        self.delegate?.progressUpload?(float)
    }
    func saveImageFinished(){
        self.delegate?.uploadImageFinished?()
    }
    
    
    func saveEvent(event : Event, usuario : User){
        eventDao?.saveEvent(event, usuario: usuario)
    }
    func getEvent(user : User, usuario : Option){
        eventDao?.getEvent(user, usuario: usuario)
    }
    func inviteFriendsToEvent(event : Event, sender : User,  friends : Array<User>){
        if(friends.count == 0 ){
            let error : NSError = NSError(domain: "God damn it", code: 3, userInfo: nil)
            self.delegate?.errorThrowedSystem(error)
            return
        }
        eventDao?.inviteFriendsToEvent(event, sender: sender, friends: friends)
    }
    
}
//
//import Foundation
//import UIKit
//
//@objc protocol UserManagerDelegate{
//    func errorThrowed(error: NSError)
//    optional func userNotFound(user : User)
//    optional func getUserFinished(user: User)
//    optional func userStillInserted(user: User)
//    optional func saveUserFinished()
//    optional func progressUpload(float : Float)
//    
//}
//
//class UserManager: UserDAOCloudKitDelegate, PictureCloudKitDelegate{
//    
//    private var userDao: UserDAOCloudKit?
//    private var pictureDao : PictureCloudKit?
//    var delegate:UserManagerDelegate?
//    
//    init(){
//        userDao = UserDAOCloudKit()
//        userDao?.delegate = self
//        pictureDao = PictureCloudKit()
//        pictureDao?.delegate = self
//    }
//    
//    func errorCloudKit(error: NSError){
//        self.delegate?.errorThrowed(error)
//    }
//    func progressUpload(float : Float){
//        self.delegate?.progressUpload?(float)
//    }
//    
//    func errorThrowed(error: NSError){
//        self.delegate?.errorThrowed(error)
//    }
//    
//    func userStillInserted(user: User){
//        self.delegate?.userStillInserted!(user)
//    }
//    
//    func saveUserFinished(user: User){
//        pictureDao?.uploadImageUser(user)
//    }
//    
//    func userNotFound(user : User){
//        self.delegate?.userNotFound?(user)
//    }
//    
//    func getUserFinished(user: User){
//        self.delegate?.getUserFinished!(user)
//    }
//    func insertUserDatabase(user:User, password : String){
//        userDao?.saveUser(user, password: password)
//    }
//    func getUserDatabase(user:User, password : String){
//        userDao?.getUser(user, password: password)
//    }
//    func saveImageFinished(){
//        self.delegate?.saveUserFinished?()
//    }
//    
//    
//}
