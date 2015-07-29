//
//  UserManager.swift
//  MidPoint
//
//  Created by William Alvelos on 07/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//
@objc protocol EventManagerDelegate{
    optional func saveEventFinished(event: Event)
    optional func eventNotFound(event : Event)
    optional func getEventFinished(event: Event)
    optional func getEventsFinished(events: Array<Event>)
    optional func inviteFinished(event: Event)
    optional func uploadImageFinished()
    optional func progressUpload(float : Float)
    func errorThrowedSystem(error: NSError)
    optional func errorThrowedServer(stringError: String)

    optional func downloadImageFinished(image: Array<UIImage!>)
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
        self.delegate?.errorThrowedServer?(ErrorHandling.stringForError(error))
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
        eventDao?.inviteFriendsToEvent(event, sender: sender, friends: friends)
    }
    func getImages(events : Array<Event>){
        var array : Array<UIImage!> = Array()
            for event in events{
                array.append( self.eventDao?.downloadImage(event.id!))
        }
        DispatcherClass.dispatcher { () -> () in
            self.delegate?.downloadImageFinished?(array)
        }
    }
}
